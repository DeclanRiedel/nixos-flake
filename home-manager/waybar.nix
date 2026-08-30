{ inputs, pkgs, ... }:

let
  codexbar = pkgs.callPackage ../packages/codexbar.nix { };
  zedThreadRunner = inputs.zed-thread-tui.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  home.packages = [ zedThreadRunner ];

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

  home.file.".config/waybar/zed-thread-summary" = {
    executable = true;
    text = ''
      #!${pkgs.python3}/bin/python3
      import json
      import os
      import subprocess
      from pathlib import Path

      runner = "${zedThreadRunner}/bin/zed-thread-runner"
      state_dir = Path(os.environ.get("XDG_STATE_HOME", Path.home() / ".local" / "state")) / "zed-thread-runner"
      processes_path = state_dir / "processes.json"

      def current_submap():
          try:
              value = subprocess.run(
                  ["${pkgs.hyprland}/bin/hyprctl", "submap"],
                  check=False,
                  text=True,
                  stdout=subprocess.PIPE,
                  stderr=subprocess.DEVNULL,
                  timeout=0.5,
              ).stdout.strip()
          except Exception:
              return ""
          if "HYPRLAND_INSTANCE_SIGNATURE" in value or "not set" in value:
              return ""
          if value in ("", "default"):
              return ""
          return value

      def pgid_alive(pgid):
          try:
              os.killpg(int(pgid), 0)
          except ProcessLookupError:
              return False
          except PermissionError:
              return True
          except Exception:
              return False
          return True

      def load_json(path, default):
          try:
              return json.loads(path.read_text())
          except Exception:
              return default

      processes = load_json(processes_path, {})
      running = []
      stale = []
      ssh_running = []
      for key, data in processes.items():
          pgid = data.get("pgid")
          alive = isinstance(pgid, int) and pgid_alive(pgid)
          if alive:
              running.append((key, data))
              if key.startswith("ssh-connection:"):
                  ssh_running.append((key, data))
          else:
              stale.append((key, data))

      try:
          slots = subprocess.run(
              [runner, "--list-slots"],
              check=False,
              text=True,
              stdout=subprocess.PIPE,
              stderr=subprocess.DEVNULL,
              timeout=1.5,
          ).stdout.strip().splitlines()
      except Exception:
          slots = []

      classes = []
      if running:
          classes.append("running")
      if stale:
          classes.append("stale")
      if ssh_running:
          classes.append("ssh")
      submap = current_submap()
      if submap:
          classes.append("leader")
      if not classes:
          classes.append("idle")

      text_parts = ["TR"]
      if submap:
          text_parts.append("LDR")
      if running:
          text_parts.append(f"{len(running)}r")
      if ssh_running:
          text_parts.append(f"{len(ssh_running)}ssh")
      if stale:
          text_parts.append(f"{len(stale)}stale")
      if len(text_parts) == 1:
          text_parts.append("idle")

      tooltip_lines = ["zed-thread-runner"]
      if submap:
          tooltip_lines.append(f"leader: {submap}")
      if running:
          tooltip_lines.append("running:")
          for key, data in running[:8]:
              command = str(data.get("command", ""))[:80]
              tooltip_lines.append(f"  {key} :: {command}")
      if stale:
          tooltip_lines.append("stale:")
          for key, data in stale[:5]:
              tooltip_lines.append(f"  {key}")
      if slots:
          tooltip_lines.append("slots:")
          tooltip_lines.extend(f"  {line}" for line in slots[:10])
      if len(tooltip_lines) == 1:
          tooltip_lines.append("no tracked processes")

      print(json.dumps({
          "text": " ".join(text_parts),
          "tooltip": "\n".join(tooltip_lines),
          "class": classes,
      }))
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

  home.file.".config/waybar/spotify-library-status" = {
    executable = true;
    text = ''
      #!${pkgs.runtimeShell}
      set -u

      state_dir="''${XDG_RUNTIME_DIR:-/tmp}/waybar-spotify"
      state_file="$state_dir/library-state"
      uri="$(${pkgs.playerctl}/bin/playerctl -p spotify,spotifyd metadata xesam:url 2>/dev/null || true)"
      liked=false

      if [[ -n "$uri" && -s "$state_file" ]]; then
        read -r saved_uri < "$state_file" || true
        [[ "$saved_uri" == "$uri" ]] && liked=true
      fi

      if $liked; then
        printf '{"text":"♥","tooltip":"Saved to Liked Songs · right-click to remove","class":"liked"}\n'
      elif [[ -n "$uri" ]]; then
        printf '{"text":"♡","tooltip":"Save to Liked Songs · right-click to remove","class":"available"}\n'
      else
        printf '{"text":"♡","tooltip":"No active Spotify track","class":"inactive"}\n'
      fi
    '';
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
      #!${pkgs.runtimeShell}
      set -u

      action="''${1:-like}"
      cache_dir="''${XDG_CACHE_HOME:-$HOME/.cache}/spotify-player"
      state_dir="''${XDG_RUNTIME_DIR:-/tmp}/waybar-spotify"
      state_file="$state_dir/library-state"
      uri="$(${pkgs.playerctl}/bin/playerctl -p spotify,spotifyd metadata xesam:url 2>/dev/null || true)"

      notify() {
        ${pkgs.libnotify}/bin/notify-send -a "Spotify Bar" "$1" "$2"
      }

      # Library actions use the Web API token. The separate credentials.json
      # file is only needed by spotify_player's integrated audio client.
      if [[ ! -s "$cache_dir/user_client_token.json" ]]; then
        notify "Spotify authentication required" "Run: spotify_player authenticate"
        exit 1
      fi

      args=()
      message="Saved current track to Liked Songs"
      if [[ "$action" == "unlike" ]]; then
        args=(--unlike)
        message="Removed current track from Liked Songs"
      elif [[ "$action" != "like" ]]; then
        notify "Spotify Bar" "Unknown library action: $action"
        exit 2
      fi

      if output="$(${pkgs.coreutils}/bin/timeout 15 ${pkgs.spotify-player}/bin/spotify_player like "''${args[@]}" 2>&1)"; then
        mkdir -p "$state_dir"
        if [[ "$action" == "like" && -n "$uri" ]]; then
          printf '%s\n' "$uri" > "$state_file"
        else
          rm -f "$state_file"
        fi
        notify "Spotify" "$message"
        ${pkgs.procps}/bin/pkill -RTMIN+8 waybar 2>/dev/null || true
      else
        notify "Spotify library update failed" "''${output:-Check playback and run spotify_player authenticate}"
        exit 1
      fi
    '';
  };
}
