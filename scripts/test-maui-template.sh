#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
workdir="$(mktemp -d)"
trap 'rm -rf "$workdir"' EXIT

echo "using temp dir: $workdir"
cd "$workdir"

nix flake init -t "$repo_root#dotnet-maui"
git init --quiet
git add .
nix run --no-write-lock-file .# -- -c 'maui-smoke-test'
