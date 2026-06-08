{ inputs, lib, pkgs, ... }:

let
  zedThreadRunner = inputs.zed-thread-tui.packages.${pkgs.stdenv.hostPlatform.system}.default;
  slotCount = 9;
  slots = lib.range 1 slotCount;
  action = "$HOME/.local/bin/zed-thread-leader-action";
  reset = "${pkgs.hyprland}/bin/hyprctl dispatch submap reset";
  runCombo = slot: combo: "${action} ${toString slot}${combo}; ${reset}";
  slotEntryBindings = lib.concatStringsSep "\n" (
    map (slot: "bind = , ${toString slot}, submap, zedthread-${toString slot}") slots
  );
  slotActionSubmaps = lib.concatStringsSep "\n\n" (
    map
      (slot:
        let
          id = toString slot;
        in
        ''
          submap = zedthread-${id}
          bind = , escape, submap, reset
          bind = , Control_R, submap, reset
          bind = , f, exec, ${runCombo slot "f"}
          bind = SHIFT, f, exec, ${runCombo slot "F"}
          bind = , r, exec, ${runCombo slot "r"}
          bind = , x, exec, ${runCombo slot "x"}
          bind = , a, exec, ${runCombo slot "a"}
          bind = , h, exec, ${runCombo slot "h"}
          bind = SHIFT, 1, exec, ${runCombo slot "!"}
          bind = SHIFT, 2, exec, ${runCombo slot "@"}
          bind = , s, submap, zedthread-${id}-s
          bind = SHIFT, r, submap, zedthread-${id}-R

          submap = zedthread-${id}-s
          bind = , escape, submap, reset
          bind = , Control_R, submap, reset
          bind = , 1, exec, ${runCombo slot "s1"}
          bind = , 2, exec, ${runCombo slot "s2"}

          submap = zedthread-${id}-R
          bind = , escape, submap, reset
          bind = , Control_R, submap, reset
          bind = , 1, exec, ${runCombo slot "R1"}
          bind = , 2, exec, ${runCombo slot "R2"}
        '')
      slots
  );
in
{
  home.file.".config/hypr/hyprland.conf" = {
    source = ../config/hyprland.conf;
    force = true;
  };

  home.file.".local/bin/start-hyprland" = {
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash
      set -euo pipefail

      export XDG_CURRENT_DESKTOP=Hyprland
      export XDG_SESSION_DESKTOP=Hyprland
      export XDG_SESSION_TYPE=wayland
      export NIXOS_OZONE_WL=1

      if [[ -n "''${WAYLAND_DISPLAY:-}" || -n "''${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
        echo "start-hyprland must be run from a TTY, not inside an existing Wayland session." >&2
        exit 1
      fi

      exec ${pkgs.uwsm}/bin/uwsm start -e -D Hyprland hyprland.desktop
    '';
  };

  home.file.".local/bin/start-hyprpaper" = {
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash
      set -euo pipefail

      wall_dir="/home/declan/.nixos/wall"
      state_dir="''${XDG_RUNTIME_DIR:-/tmp}/hyprpaper"
      config="$state_dir/hyprpaper.conf"
      wallpaper="$wall_dir/berserk.jpg"

      mkdir -p "$state_dir"

      if [[ ! -f "$wallpaper" ]]; then
        exit 0
      fi

      monitors=()
      for _ in {1..20}; do
        if monitors_json="$(${pkgs.hyprland}/bin/hyprctl monitors -j 2>/dev/null)"; then
          mapfile -t monitors < <(printf '%s' "$monitors_json" | ${pkgs.jq}/bin/jq -r '.[].name')
          ((''${#monitors[@]} > 0)) && break
        fi
        sleep 0.1
      done

      if ((''${#monitors[@]} == 0)); then
        monitors=(eDP-1)
      fi

      {
        printf 'ipc = on\n'
        for monitor in "''${monitors[@]}"; do
          printf 'wallpaper {\n'
          printf '    monitor = %s\n' "$monitor"
          printf '    path = %s\n' "$wallpaper"
          printf '    fit_mode = cover\n'
          printf '}\n\n'
        done
      } > "$config"

      ${pkgs.procps}/bin/pkill -x hyprpaper 2>/dev/null || true
      exec ${pkgs.hyprpaper}/bin/hyprpaper --config "$config"
    '';
  };

  home.file.".local/bin/zed-thread-leader-action" = {
    executable = true;
    text = ''
      #!${pkgs.runtimeShell}
      exec ${zedThreadRunner}/bin/zed-thread-runner --leader-combo "$1"
    '';
  };

  home.file.".local/bin/wayvnc-private" = {
    executable = true;
    text = ''
      #!${pkgs.runtimeShell}
      set -euo pipefail

      state_dir="$HOME/.local/state/wayvnc"
      config="$state_dir/config"
      password_file="$state_dir/password"
      tls_key="$state_dir/tls_key.pem"
      tls_cert="$state_dir/tls_cert.pem"
      rsa_key="$state_dir/rsa_key.pem"
      socket="''${XDG_RUNTIME_DIR:-/tmp}/wayvncctl-private"
      address="127.0.0.1"
      port="5901"

      mkdir -p "$state_dir"
      chmod 700 "$state_dir"

      if [[ ! -s "$password_file" ]]; then
        ${pkgs.openssl}/bin/openssl rand -base64 24 > "$password_file"
        chmod 600 "$password_file"
      fi

      if [[ ! -s "$tls_key" || ! -s "$tls_cert" ]]; then
        ${pkgs.openssl}/bin/openssl req -x509 -nodes -newkey rsa:2048 \
          -keyout "$tls_key" \
          -out "$tls_cert" \
          -subj "/CN=wayvnc-localhost" \
          -days 3650 >/dev/null 2>&1
        chmod 600 "$tls_key" "$tls_cert"
      fi

      if [[ ! -s "$rsa_key" ]]; then
        ${pkgs.openssl}/bin/openssl genrsa -out "$rsa_key" 2048 >/dev/null 2>&1
        chmod 600 "$rsa_key"
      fi

      cat > "$config" <<EOF
      address=$address
      port=$port
      enable_auth=true
      username=declan
      password=$(cat "$password_file")
      private_key_file=$tls_key
      certificate_file=$tls_cert
      rsa_private_key_file=$rsa_key
      EOF
      chmod 600 "$config"

      case "''${1:---start}" in
        --password)
          cat "$password_file"
          ;;
        --stop)
          ${pkgs.procps}/bin/pkill -u "$USER" -f "${pkgs.wayvnc}/bin/wayvnc.*$socket" || true
          ;;
        --toggle)
          if ${pkgs.procps}/bin/pgrep -u "$USER" -f "${pkgs.wayvnc}/bin/wayvnc.*$socket" >/dev/null; then
            exec "$0" --stop
          fi
          exec "$0" --start
          ;;
        --start)
          if ${pkgs.procps}/bin/pgrep -u "$USER" -f "${pkgs.wayvnc}/bin/wayvnc.*$socket" >/dev/null; then
            exit 0
          fi
          exec ${pkgs.wayvnc}/bin/wayvnc --config="$config" --socket="$socket" "$address" "$port"
          ;;
        *)
          echo "usage: wayvnc-private [--start|--stop|--toggle|--password]" >&2
          exit 2
          ;;
      esac
    '';
  };

  home.file.".local/bin/hypr-record" = {
    executable = true;
    text = ''
      #!${pkgs.runtimeShell}
      set -euo pipefail

      state_dir="''${XDG_RUNTIME_DIR:-/tmp}"
      pid_file="$state_dir/hypr-record.pid"
      output_dir="$HOME/Media/Recordings"

      notify() {
        ${pkgs.libnotify}/bin/notify-send "Screen recording" "$1" >/dev/null 2>&1 || true
      }

      if [[ -s "$pid_file" ]] && ${pkgs.procps}/bin/kill -0 "$(<"$pid_file")" 2>/dev/null; then
        ${pkgs.procps}/bin/kill -INT "$(<"$pid_file")"
        rm -f "$pid_file"
        notify "Saved recording"
        exit 0
      fi

      mkdir -p "$output_dir"
      geometry="$(${pkgs.slurp}/bin/slurp)"
      [[ -n "$geometry" ]]

      filename="$output_dir/recording-$(${pkgs.coreutils}/bin/date +%Y%m%d-%H%M%S).mp4"
      ${pkgs.wl-screenrec}/bin/wl-screenrec \
        --geometry "$geometry" \
        --audio \
        --filename "$filename" &

      echo "$!" > "$pid_file"
      notify "Recording region. Press Super+H again to stop."
    '';
  };

  home.file.".config/hypr/zed-thread-leader.conf" = {
    text = ''
      # zed-thread-runner global leader bindings.
      # Press Right Ctrl, then a slot number, then an action.
      bind = , Control_R, submap, zedthread

      submap = zedthread
      bind = , escape, submap, reset
      bind = , Control_R, submap, reset
      ${slotEntryBindings}

      ${slotActionSubmaps}

      submap = reset
    '';
  };
}
