#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

usage() {
  cat <<'EOF'
Usage:
  scripts/switch.sh [host]
  scripts/switch.sh --list

Hosts:
  vostro      Laptop/desktop Hyprland system.
  nixos-wsl   Terminal-first WSL2 development system.
  mc-bedrock  Minimal headless Minecraft Bedrock server.

If no host is provided, the current hostname is used.
EOF
}

case "${1:-}" in
  -h|--help)
    usage
    exit 0
    ;;
  -l|--list)
    nix eval --raw .#nixosConfigurations --apply 'hosts: builtins.concatStringsSep "\n" (builtins.attrNames hosts)'
    echo
    exit 0
    ;;
esac

host="${1:-$(hostname)}"

# Cheap host-name check: only reads the nixosConfigurations attr NAMES without
# forcing the (expensive) full system evaluation that nixos-rebuild does later.
if ! nix eval --raw ".#nixosConfigurations" \
  --apply 'hosts: builtins.concatStringsSep "\n" (builtins.attrNames hosts)' 2>/dev/null \
  | grep -qx "$host"; then
  echo "Unknown host: $host" >&2
  echo >&2
  usage >&2
  exit 1
fi

sudo nixos-rebuild switch --flake "path:$PWD#$host"
