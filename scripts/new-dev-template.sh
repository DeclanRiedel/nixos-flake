#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"

usage() {
  cat <<'USAGE'
Usage:
  new-dev-template.sh --list
  new-dev-template.sh <template> [target-dir]

Examples:
  new-dev-template.sh dotnet
  new-dev-template.sh rust ./my-rust-app
USAGE
}

list_templates() {
  nix eval --raw "$repo_root#templates" --apply '
    templates:
      builtins.concatStringsSep "\n"
        (map
          (name: "${name}\t${templates.${name}.description}")
          (builtins.attrNames templates))
  '
}

case "${1:-}" in
  --list | list)
    list_templates
    ;;
  -h | --help | "")
    usage
    ;;
  *)
    template="$1"
    target="${2:-.}"

    if ! list_templates | cut -f1 | grep -Fxq "$template"; then
      echo "Unknown template: $template" >&2
      echo >&2
      list_templates >&2
      exit 2
    fi

    if [ "$target" = "." ]; then
      nix flake init -t "$repo_root#$template"
    else
      nix flake new -t "$repo_root#$template" "$target"
    fi
    ;;
esac
