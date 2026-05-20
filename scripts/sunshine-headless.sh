#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: sunshine-headless.sh [options]

Start a temporary headless Hyprland session and launch Sunshine inside it.
Useful from SSH when you want a Moonlight client to connect without a physical
display being active.

Options:
  -r, --resolution WIDTHxHEIGHT  Virtual display resolution (default: 1920x1080)
  -f, --refresh HZ               Virtual display refresh rate (default: 60)
  -s, --scale SCALE              Hyprland monitor scale (default: 1)
  -n, --name NAME                Headless monitor name (default: HEADLESS-0)
      --no-sunshine              Start only Hyprland, not Sunshine
  -h, --help                     Show this help

Environment overrides:
  SUNSHINE_HEADLESS_RESOLUTION, SUNSHINE_HEADLESS_REFRESH,
  SUNSHINE_HEADLESS_SCALE, SUNSHINE_HEADLESS_MONITOR
EOF
}

resolution="${SUNSHINE_HEADLESS_RESOLUTION:-1920x1080}"
refresh="${SUNSHINE_HEADLESS_REFRESH:-60}"
scale="${SUNSHINE_HEADLESS_SCALE:-1}"
monitor="${SUNSHINE_HEADLESS_MONITOR:-HEADLESS-0}"
start_sunshine=1

while [[ $# -gt 0 ]]; do
  case "$1" in
    -r|--resolution)
      resolution="${2:?missing resolution}"
      shift 2
      ;;
    -f|--refresh)
      refresh="${2:?missing refresh rate}"
      shift 2
      ;;
    -s|--scale)
      scale="${2:?missing scale}"
      shift 2
      ;;
    -n|--name)
      monitor="${2:?missing monitor name}"
      shift 2
      ;;
    --no-sunshine)
      start_sunshine=0
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ ! "$resolution" =~ ^[0-9]+x[0-9]+$ ]]; then
  printf 'Invalid resolution: %s\n' "$resolution" >&2
  exit 2
fi

if [[ ! "$refresh" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
  printf 'Invalid refresh rate: %s\n' "$refresh" >&2
  exit 2
fi

for cmd in dbus-run-session Hyprland; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    printf 'Missing required command: %s\n' "$cmd" >&2
    exit 1
  fi
done

if [[ ! -S /run/seatd.sock ]]; then
  cat >&2 <<'EOF'
Warning: /run/seatd.sock is missing.
Standalone headless Hyprland from SSH usually needs services.seatd.enable = true
and your user in the "seat" group. Rebuild, then start a new SSH login.
EOF
fi

if ! id -nG | grep -qw seat; then
  cat >&2 <<'EOF'
Warning: this login is not in the "seat" group.
If you just changed group membership, log out and SSH back in after rebuilding.
EOF
fi

if (( start_sunshine )) && ! command -v sunshine >/dev/null 2>&1; then
  printf 'Missing required command: sunshine\n' >&2
  exit 1
fi

sunshine_conf="${XDG_CONFIG_HOME:-$HOME/.config}/sunshine/sunshine.conf"
if (( start_sunshine )) && [[ -f "$sunshine_conf" ]] && grep -Eq '^[[:space:]]*capture[[:space:]]*=[[:space:]]*kms[[:space:]]*$' "$sunshine_conf"; then
  cat >&2 <<EOF
Warning: ${sunshine_conf} forces "capture = kms".
Hyprland virtual/headless displays normally need Sunshine capture set to "wlr".
EOF
fi

if [[ -z "${XDG_RUNTIME_DIR:-}" ]]; then
  XDG_RUNTIME_DIR="/run/user/$(id -u)"
  export XDG_RUNTIME_DIR
fi

if [[ ! -d "$XDG_RUNTIME_DIR" ]]; then
  printf 'Missing XDG_RUNTIME_DIR: %s\n' "$XDG_RUNTIME_DIR" >&2
  printf 'SSH in as the target desktop user, not root, so systemd-logind creates /run/user/%s.\n' "$(id -u)" >&2
  exit 1
fi

runtime_dir="$(mktemp -d "${TMPDIR:-/tmp}/sunshine-headless.XXXXXX")"
config="$runtime_dir/hyprland-headless.conf"
log="$runtime_dir/session.log"
sunshine_pid_file="$runtime_dir/sunshine.pid"
keep_runtime_dir=0

cleanup() {
  if [[ -s "$sunshine_pid_file" ]]; then
    sunshine_pid="$(<"$sunshine_pid_file")"
    if [[ "$sunshine_pid" =~ ^[0-9]+$ ]]; then
      kill "$sunshine_pid" >/dev/null 2>&1 || true
    fi
  fi
  if (( keep_runtime_dir == 0 )); then
    rm -rf "$runtime_dir"
  fi
}
trap cleanup EXIT

cat >"$config" <<EOF
monitor = ${monitor},${resolution}@${refresh},auto,${scale}

xwayland {
    force_zero_scaling = true
}

env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland

input {
    kb_layout = us
    follow_mouse = 1
}

general {
    gaps_in = 0
    gaps_out = 0
    border_size = 1
    layout = dwindle
}

decoration {
    rounding = 0
    blur {
        enabled = false
    }
}

animations {
    enabled = false
}

misc {
    disable_hyprland_logo = true
    force_default_wallpaper = 0
}

debug {
    disable_logs = false
}

exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE HYPRLAND_INSTANCE_SIGNATURE
EOF

if (( start_sunshine )); then
  cat >>"$config" <<EOF
exec-once = sh -c 'sunshine & echo \$! > "${sunshine_pid_file}"'
EOF
fi

cat >&2 <<EOF
Starting headless Hyprland for Sunshine
  monitor: ${monitor}
  mode:    ${resolution}@${refresh}
  scale:   ${scale}
  log:     ${log}

Leave this SSH command running while streaming. Press Ctrl-C to stop the
headless session and Sunshine.
EOF

export AQ_NO_KMS_REQUIREMENT=1
export WLR_LIBINPUT_NO_DEVICES=1

if dbus-run-session Hyprland --config "$config" >"$log" 2>&1; then
  status=0
else
  status=$?
  keep_runtime_dir=1
  cat >&2 <<EOF

Headless Hyprland exited with status ${status}.
Keeping debug files in: ${runtime_dir}

Last log lines:
EOF
  tail -n 80 "$log" >&2 || true
  exit "$status"
fi
