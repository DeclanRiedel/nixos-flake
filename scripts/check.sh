#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

nix flake check --impure path:/home/declan/.nixos
nix build --impure --expr \
  '(builtins.getFlake "path:/home/declan/.nixos").nixosConfigurations.vostro.config.system.build.toplevel' \
  --no-link
