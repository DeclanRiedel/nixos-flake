#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if ! command -v mkpasswd >/dev/null 2>&1 ||
  ! command -v sops >/dev/null 2>&1 ||
  ! command -v ssh-to-age >/dev/null 2>&1; then
  exec nix shell nixpkgs#sops nixpkgs#ssh-to-age nixpkgs#whois -c "$0" "$@"
fi

secrets_dir="secrets"
sops_file="$secrets_dir/default.yaml"
host_ssh_pub="/etc/ssh/ssh_host_ed25519_key.pub"

mkdir -p "$secrets_dir"
chmod 700 "$secrets_dir"

hash_password() {
  local user="$1"
  local secret_name="$2"
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

  printf '%s: "%s"\n' "$secret_name" "$(printf '%s\n' "$password" | mkpasswd -m sha-512 -s)"
}

if [[ ! -f "$host_ssh_pub" ]]; then
  printf 'Missing host SSH public key: %s\n' "$host_ssh_pub" >&2
  exit 1
fi

if [[ "$#" -ne 0 ]]; then
  printf 'Usage: %s\n' "$0" >&2
  exit 1
fi

recipient="$(ssh-to-age -i "$host_ssh_pub")"
plain="$(mktemp)"
trap 'rm -f "$plain"' EXIT

{
  hash_password declan declan-password
  hash_password root root-password
} > "$plain"

sops --encrypt --age "$recipient" --filename-override "$sops_file" "$plain" > "$sops_file"
chmod 600 "$sops_file"
printf 'Wrote encrypted secrets to %s\n' "$sops_file"
