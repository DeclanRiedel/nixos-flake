#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

nix flake check --impure "path:$PWD"
nix build --impure --expr \
  '(builtins.getFlake "path:'"$PWD"'").nixosConfigurations.vostro.config.system.build.toplevel' \
  --no-link
