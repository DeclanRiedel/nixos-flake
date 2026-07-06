{ inputs, pkgs, ... }:

let
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
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash
      if systemctl is-active --quiet wireguard-wg0.service; then
        printf '{"text":"VPN","alt":"on","class":"active","tooltip":"WireGuard: connected (wg0) - click to disconnect"}\n'
      else
        printf '{"text":"VPN","alt":"off","class":"inactive","tooltip":"WireGuard: disconnected - click to connect"}\n'
      fi
    '';
  };

  home.file.".config/waybar/vpn-toggle" = {
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash
      if systemctl is-active --quiet wireguard-wg0.service; then
        sudo /run/current-system/sw/bin/systemctl stop wireguard-wg0.service
      else
        sudo /run/current-system/sw/bin/systemctl start wireguard-wg0.service
      fi
    '';
  };
}
