#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

mapfile -t templates < <(nix eval --raw .#templates --apply '
  templates: builtins.concatStringsSep "\n" (builtins.attrNames templates)
')

for template in "${templates[@]}"; do
  echo "checking template: $template"
  nix flake show --no-write-lock-file "./templates/$template" --all-systems >/dev/null
done
