#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

secrets_dir="secrets/passwords"
mkdir -p "$secrets_dir"
chmod 700 secrets "$secrets_dir"

hash_password() {
  local user="$1"
  local output="$secrets_dir/$user.hash"
  local password
  local confirm

  while true; do
    read -rsp "Password for $user: " password
    printf '\n'
    read -rsp "Confirm password for $user: " confirm
    printf '\n'

    if [[ "$password" != "$confirm" ]]; then
      printf 'Passwords did not match. Try again.\n' >&2
      continue
    fi

    if [[ -z "$password" ]]; then
      printf 'Password cannot be empty. Try again.\n' >&2
      continue
    fi

    break
  done

  mkpasswd -m sha-512 "$password" > "$output"
  chmod 600 "$output"
  printf 'Wrote %s\n' "$output"
}

if ! command -v mkpasswd >/dev/null 2>&1; then
  printf 'mkpasswd is required. On NixOS, run: nix shell nixpkgs#whois\n' >&2
  exit 1
fi

users=("$@")
if [[ "${#users[@]}" -eq 0 ]]; then
  users=(declan root)
fi

for user in "${users[@]}"; do
  hash_password "$user"
done
