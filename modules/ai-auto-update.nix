{ hostConfig, pkgs, ... }:

let
  inherit (hostConfig) hostName;
  inherit (hostConfig.user) home name;
  flakeDir = "${home}/.nixos";
  aiAutoUpdate = pkgs.writeShellScript "ai-auto-update" ''
    set -euo pipefail
    cd ${flakeDir}
    ${pkgs.util-linux}/bin/runuser -u ${name} -- \
      env HOME=${home} ${pkgs.nix}/bin/nix flake update nixpkgs-codex
    ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch \
      --flake "path:${flakeDir}#${hostName}"
  '';
in
{
  systemd.services.ai-auto-update = {
    description = "Auto-update Codex from nixpkgs master";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = aiAutoUpdate;
    };
  };

  systemd.timers.ai-auto-update = {
    description = "Periodically auto-update AI tools";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5min";
      OnUnitActiveSec = "24h";
      Persistent = true;
      RandomizedDelaySec = "10m";
    };
  };
}
