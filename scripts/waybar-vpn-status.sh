#!/usr/bin/env bash
if systemctl is-active --quiet wireguard-wg0.service; then
  printf '{"text":"VPN","alt":"on","class":"active","tooltip":"WireGuard: connected (wg0) - click to disconnect"}\n'
else
  printf '{"text":"VPN","alt":"off","class":"inactive","tooltip":"WireGuard: disconnected - click to connect"}\n'
fi
