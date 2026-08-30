{ inputs, pkgs, ... }:

let
  codexbar = pkgs.callPackage ../packages/codexbar.nix { };
  spotifyPlayer = inputs.nixpkgs-codex.legacyPackages.${pkgs.stdenv.hostPlatform.system}.spotify-player;
  t3codeNightly = pkgs.callPackage ../packages/t3code-nightly.nix { };
  zedThreadRunner = inputs.zed-thread-tui.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  home.packages = [
    t3codeNightly
    zedThreadRunner
  ];

  home.file.".config/waybar/config" = {
    source = ../config/waybar/config;
    force = true;
  };

  home.file.".config/waybar/style.css" = {
    source = ../config/waybar/style.css;
    force = true;
  };

  home.file.".config/waybar/mocha.css" = {
    source = ../config/waybar/mocha.css;
    force = true;
  };

  home.file.".config/waybar/t3code-attention" = {
    executable = true;
    text = ''
      #!${pkgs.python3}/bin/python3
      import fcntl
      import json
      import os
      import sqlite3
      import subprocess
      import sys
      from pathlib import Path
      from urllib.parse import quote

      home = Path.home()
      t3_dir = home / ".t3" / "userdata"
      database = t3_dir / "state.sqlite"
      environment_file = t3_dir / "environment-id"
      state_dir = Path(os.environ.get("XDG_STATE_HOME", home / ".local" / "state")) / "waybar"
      state_file = state_dir / "t3code-attention.json"
      lock_file = state_dir / "t3code-attention.lock"
      t3code = "${t3codeNightly}/bin/t3code-nightly"

      PROVIDERS = {
          "codex": ("C", "Codex"),
          "claude": ("Cl", "Claude"),
      }

      def provider_key(value):
          name = str(value or "").lower()
          if name.startswith("codex"):
              return "codex"
          if name.startswith("claude"):
              return "claude"
          return None

      def load_state():
          try:
              payload = json.loads(state_file.read_text())
              if payload.get("version") == 1 and isinstance(payload.get("acknowledged"), dict):
                  return payload
          except Exception:
              pass
          return {"version": 1, "initialized": False, "acknowledged": {}}

      def save_state(state):
          state_dir.mkdir(parents=True, exist_ok=True)
          temporary = state_file.with_suffix(".tmp")
          temporary.write_text(json.dumps(state, separators=(",", ":")))
          os.chmod(temporary, 0o600)
          temporary.replace(state_file)

      def snapshot():
          if not database.is_file():
              return []
          connection = sqlite3.connect(f"file:{database}?mode=ro", uri=True, timeout=0.2)
          connection.row_factory = sqlite3.Row
          try:
              rows = connection.execute(
                  """
                  SELECT
                    t.thread_id,
                    t.title,
                    COALESCE(s.provider_name, json_extract(t.model_selection_json, '$.provider')) AS provider,
                    t.updated_at,
                    t.pending_approval_count,
                    t.pending_user_input_count,
                    v.turn_id,
                    v.state AS turn_state,
                    v.completed_at,
                    s.status AS session_status,
                    s.updated_at AS session_updated_at
                  FROM projection_threads AS t
                  LEFT JOIN projection_thread_sessions AS s USING (thread_id)
                  LEFT JOIN projection_turns AS v
                    ON v.thread_id = t.thread_id AND v.turn_id = t.latest_turn_id
                  WHERE t.deleted_at IS NULL AND t.archived_at IS NULL
                  """
              ).fetchall()
          finally:
              connection.close()

          result = []
          for row in rows:
              provider = provider_key(row["provider"])
              if provider is None:
                  continue
              approval_count = int(row["pending_approval_count"] or 0)
              input_count = int(row["pending_user_input_count"] or 0)
              kind = None
              fingerprint = None
              if approval_count or input_count:
                  kind = "input"
                  fingerprint = "input:{}:{}:{}".format(
                      approval_count,
                      input_count,
                      row["updated_at"] or "",
                  )
              elif row["turn_state"] == "completed" or (
                  row["turn_state"] == "interrupted" and row["completed_at"]
              ):
                  kind = "done"
                  fingerprint = "done:{}:{}".format(
                      row["turn_id"] or "",
                      row["completed_at"] or row["updated_at"] or "",
                  )
              elif row["session_status"] in ("ready", "idle"):
                  kind = "done"
                  fingerprint = "done:ready:{}".format(row["session_updated_at"] or "")

              result.append({
                  "thread_id": row["thread_id"],
                  "title": row["title"],
                  "provider": provider,
                  "kind": kind,
                  "fingerprint": fingerprint,
                  "updated_at": row["updated_at"] or "",
                  "approval_count": approval_count,
                  "input_count": input_count,
              })
          return result

      def unread_items(rows, state):
          acknowledged = state["acknowledged"]
          return [
              row for row in rows
              if row["fingerprint"] is not None
              and acknowledged.get(row["thread_id"]) != row["fingerprint"]
          ]

      def render(items):
          if not items:
              print(json.dumps({"text": "", "tooltip": "", "class": "empty"}))
              return
          text = "!{}".format(len(items))
          lines = ["T3 Code needs attention"]
          for item in sorted(items, key=lambda row: (row["kind"] != "input", row["updated_at"])):
              reason = "input required" if item["kind"] == "input" else "work finished"
              lines.append("{} · {} · {}".format(
                  PROVIDERS[item["provider"]][1], reason, item["title"]
              ))
          lines.extend(["", "Click: view next thread", "Right-click: mark all viewed"])
          css_class = "input" if any(item["kind"] == "input" for item in items) else "done"
          print(json.dumps({"text": text, "tooltip": "\n".join(lines), "class": css_class}))

      def launch_thread(item=None):
          command = [t3code]
          if item is not None:
              try:
                  environment_id = environment_file.read_text().strip()
              except Exception:
                  environment_id = ""
              if environment_id:
                  command.append("t3code://threads/{}/{}".format(
                      quote(environment_id, safe=""),
                      quote(item["thread_id"], safe=""),
                  ))
          subprocess.Popen(
              command,
              stdin=subprocess.DEVNULL,
              stdout=subprocess.DEVNULL,
              stderr=subprocess.DEVNULL,
              start_new_session=True,
          )

      def refresh_waybar():
          subprocess.run(
              ["${pkgs.procps}/bin/pkill", "-RTMIN+10", "waybar"],
              check=False,
              stdout=subprocess.DEVNULL,
              stderr=subprocess.DEVNULL,
          )

      action = sys.argv[1] if len(sys.argv) > 1 else "status"
      state_dir.mkdir(parents=True, exist_ok=True)
      with lock_file.open("a+") as lock:
          fcntl.flock(lock, fcntl.LOCK_EX)
          rows = snapshot()
          state = load_state()
          if not state["initialized"] and database.is_file():
              state["acknowledged"] = {
                  row["thread_id"]: row["fingerprint"]
                  for row in rows if row["fingerprint"] is not None
              }
              state["initialized"] = True
              save_state(state)

          items = unread_items(rows, state)
          if action == "status":
              render(items)
          elif action == "view":
              item = sorted(
                  items,
                  key=lambda row: (row["kind"] != "input", row["updated_at"]),
              )[0] if items else None
              if item is not None:
                  state["acknowledged"][item["thread_id"]] = item["fingerprint"]
                  save_state(state)
              launch_thread(item)
              refresh_waybar()
          elif action == "clear":
              for item in items:
                  state["acknowledged"][item["thread_id"]] = item["fingerprint"]
              save_state(state)
              refresh_waybar()
          else:
              raise SystemExit("usage: t3code-attention {status|view|clear}")
    '';
  };

  home.file.".config/waybar/vpn-status" = {
    source = ../scripts/waybar-vpn-status.sh;
    executable = true;
  };

  home.file.".config/waybar/vpn-toggle" = {
    source = ../scripts/waybar-vpn-toggle.sh;
    executable = true;
  };

  home.file.".config/waybar/ai-usage" = {
    executable = true;
    text = ''
      #!${pkgs.python3}/bin/python3
      import json
      import subprocess

      providers = {"claude": "Cla", "codex": "Cod"}

      try:
          result = subprocess.run(
              ["${codexbar}/bin/codexbar", "usage", "--provider", "both", "--format", "json"],
              check=True,
              capture_output=True,
              text=True,
              timeout=60,
          )
          payload = json.loads(result.stdout)
          entries = payload if isinstance(payload, list) else [payload]
          usage = []
          for entry in entries:
              name = str(entry.get("provider", "")).lower()
              windows = entry.get("usage") or {}
              weekly = windows.get("secondary") or {}
              session = windows.get("primary") or {}
              used = weekly.get("usedPercent")
              remaining = None if used is None else max(0, round(100 - used))
              session_used = session.get("usedPercent")
              session_left = None if session_used is None else max(0, round(100 - session_used))
              if name in providers and not entry.get("error"):
                  usage.append((name, remaining, session_left, weekly.get("resetDescription", "")))

          if not usage:
              raise RuntimeError("no usage data")

          usage.sort(key=lambda item: list(providers).index(item[0]))
          text = "  ".join(
              f"{providers[name]} {'–' if weekly is None else str(weekly) + '%'}"
              for name, weekly, _session, _reset in usage
          )
          tooltip = ["AI subscription usage"]
          for name, weekly, session, reset in usage:
              tooltip.append(
                  f"{name.title()}: session {'—' if session is None else str(session) + '%'} · "
                  f"weekly {'—' if weekly is None else str(weekly) + '%'}"
              )
              if reset:
                  tooltip.append(f"  resets {reset}")

          known = [weekly for _name, weekly, _session, _reset in usage if weekly is not None]
          lowest = min(known) if known else 100
          css_class = "critical" if lowest <= 20 else "warning" if lowest <= 45 else "ok"
          print(json.dumps({"text": text, "tooltip": "\n".join(tooltip), "class": css_class}))
      except Exception as error:
          print(json.dumps({"text": "AI —", "tooltip": f"CodexBar: {error}", "class": "error"}))
    '';
  };

  home.file.".config/waybar/spotify-library" = {
    executable = true;
    text = ''
      #!${pkgs.python3}/bin/python3
      import json
      import os
      import re
      import subprocess
      import sys
      import urllib.error
      import urllib.parse
      import urllib.request
      from pathlib import Path

      playerctl = "${pkgs.playerctl}/bin/playerctl"
      spotify_player = "${spotifyPlayer}/bin/spotify_player"
      token_file = Path(os.environ.get("XDG_CACHE_HOME", Path.home() / ".cache")) / "spotify-player" / "user_client_token.json"
      api_root = "https://api.spotify.com/v1/me/library"

      class AuthenticationRequired(Exception):
          pass

      def current_uri():
          result = subprocess.run(
              [playerctl, "-p", "spotify", "metadata", "xesam:url"],
              check=False,
              capture_output=True,
              text=True,
              timeout=2,
          )
          match = re.fullmatch(
              r"https?://open\.spotify\.com/track/([A-Za-z0-9]{22})(?:[/?].*)?",
              result.stdout.strip(),
          )
          return None if match is None else "spotify:track:" + match.group(1)

      def access_token():
          try:
              token = json.loads(token_file.read_text()).get("access_token")
          except Exception as error:
              raise AuthenticationRequired from error
          if not isinstance(token, str) or not token:
              raise AuthenticationRequired
          return token

      def refresh_token():
          subprocess.run(
              [spotify_player, "get", "key", "playback"],
              check=False,
              stdin=subprocess.DEVNULL,
              stdout=subprocess.DEVNULL,
              stderr=subprocess.DEVNULL,
              timeout=15,
          )

      def request(method, uri, retry=True):
          query = urllib.parse.urlencode({"uris": uri})
          endpoint = api_root + ("/contains" if method == "GET" else "") + "?" + query
          call = urllib.request.Request(
              endpoint,
              method=method,
              headers={"Authorization": "Bearer " + access_token()},
          )
          try:
              with urllib.request.urlopen(call, timeout=8) as response:
                  return response.read()
          except urllib.error.HTTPError as error:
              if error.code == 401 and retry:
                  refresh_token()
                  return request(method, uri, retry=False)
              if error.code == 401:
                  raise AuthenticationRequired from error
              raise RuntimeError("Spotify API returned HTTP {}".format(error.code)) from error

      def is_liked(uri):
          payload = json.loads(request("GET", uri))
          return bool(payload and payload[0])

      def notify(summary, body):
          subprocess.run(
              ["${pkgs.libnotify}/bin/notify-send", "-a", "Spotify Bar", summary, body],
              check=False,
          )

      def authenticate():
          notify("Spotify authentication required", "Complete the login in the terminal, then click the heart again")
          subprocess.Popen(
              ["${pkgs.ghostty}/bin/ghostty", "-e", spotify_player, "authenticate"],
              stdin=subprocess.DEVNULL,
              stdout=subprocess.DEVNULL,
              stderr=subprocess.DEVNULL,
              start_new_session=True,
          )

      def refresh_waybar():
          subprocess.run(
              ["${pkgs.procps}/bin/pkill", "-RTMIN+8", "waybar"],
              check=False,
              stdout=subprocess.DEVNULL,
              stderr=subprocess.DEVNULL,
          )

      action = sys.argv[1] if len(sys.argv) > 1 else "status"
      uri = current_uri()
      if uri is None:
          if action == "status":
              print(json.dumps({"text": "", "tooltip": "", "class": "inactive"}))
          else:
              notify("Spotify", "No Spotify track is selected")
          raise SystemExit(0)

      try:
          liked = is_liked(uri)
          if action == "status":
              if liked:
                  print(json.dumps({"text": "", "tooltip": "Remove from Your Library", "class": "liked"}))
              else:
                  print(json.dumps({"text": "", "tooltip": "Save to Your Library", "class": "available"}))
          elif action in ("toggle", "like", "unlike"):
              should_like = not liked if action == "toggle" else action == "like"
              if should_like != liked:
                  request("PUT" if should_like else "DELETE", uri)
              notify("Spotify", "Saved to Your Library" if should_like else "Removed from Your Library")
              refresh_waybar()
          else:
              raise SystemExit("usage: spotify-library {status|toggle|like|unlike}")
      except AuthenticationRequired:
          if action == "status":
              print(json.dumps({"text": "?", "tooltip": "Spotify login required", "class": "auth"}))
          else:
              authenticate()
      except Exception as error:
          if action == "status":
              print(json.dumps({"text": "!", "tooltip": str(error), "class": "error"}))
          else:
              notify("Spotify library update failed", str(error))
    '';
  };
}
