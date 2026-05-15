#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

host="${1:-$(hostname)}"

sudo nixos-rebuild switch --flake "path:$PWD#$host"
