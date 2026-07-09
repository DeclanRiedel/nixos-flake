#!/usr/bin/env bash
if systemctl is-active --quiet wireguard-wg0.service; then
  sudo /run/current-system/sw/bin/systemctl stop wireguard-wg0.service
else
  sudo /run/current-system/sw/bin/systemctl start wireguard-wg0.service
fi
