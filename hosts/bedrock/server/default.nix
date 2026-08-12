{ lib, pkgs, ... }:

let
  bedrockPackage = pkgs.callPackage ./package.nix { };
  dataDir = "/var/lib/minecraft-bedrock";
  backupDir = "${dataDir}/backups";
  configFiles = [ "server.properties" "allowlist.json" "permissions.json" ];

  backupScript = pkgs.writeShellScript "minecraft-bedrock-backup" ''
    set -euo pipefail

    if ! systemctl is-active --quiet minecraft-bedrock; then
      echo "Server is not running; skipping backup."
      exit 0
    fi

    recent="$(${pkgs.systemd}/bin/journalctl -u minecraft-bedrock --no-pager -n 2000 2>/dev/null || true)"
    connected=$(printf '%s\n' "$recent" | ${pkgs.gnugrep}/bin/grep -oP 'Player connected: \K[^,]+' | sort -u || true)
    disconnected=$(printf '%s\n' "$recent" | ${pkgs.gnugrep}/bin/grep -oP 'Player disconnected: \K[^,]+' | sort -u || true)
    current=$(comm -23 <(printf '%s\n' "$connected") <(printf '%s\n' "$disconnected") || true)
    player_count=$(printf '%s\n' "$current" | ${pkgs.gnugrep}/bin/grep -c . || true)

    if [ "$player_count" -ne 0 ]; then
      echo "$player_count player(s) online; skipping backup."
      exit 0
    fi

    mkdir -p ${backupDir}
    systemctl stop minecraft-bedrock

    restart_server() {
      systemctl start minecraft-bedrock
    }
    trap restart_server EXIT

    timestamp=$(date +%Y%m%d-%H%M%S)
    ${pkgs.gnutar}/bin/tar -czf "${backupDir}/world-$timestamp.tar.gz" -C ${dataDir} worlds/
    chown -R minecraft:minecraft ${backupDir}

    cd ${backupDir}
    ls -1t world-*.tar.gz 2>/dev/null | tail -n +6 | xargs -r rm -f
  '';
in
{
  networking.firewall.allowedUDPPorts = [ 19132 19133 ];

  users = {
    groups.minecraft = { };
    users.minecraft = {
      isSystemUser = true;
      group = "minecraft";
      home = dataDir;
      createHome = true;
    };
  };

  systemd.services = {
    minecraft-bedrock = {
      description = "Minecraft Bedrock Dedicated Server";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.coreutils ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${bedrockPackage}/bin/bedrock-server";
        WorkingDirectory = dataDir;
        User = "minecraft";
        Group = "minecraft";
        Restart = "on-failure";
        RestartSec = 10;
      };

      preStart = ''
        ${pkgs.rsync}/bin/rsync -a --chmod=u+w --ignore-existing \
          ${bedrockPackage}/lib/bedrock-server/ ${dataDir}/
        ${lib.concatMapStringsSep "\n" (file: ''
          install -m 0644 ${./. + "/${file}"} ${dataDir}/${file}
        '') configFiles}
        chown -R minecraft:minecraft ${dataDir}
        chmod -R u+rw ${dataDir}
      '';
    };

    minecraft-bedrock-backup = {
      description = "Minecraft Bedrock World Backup";
      path = with pkgs; [ coreutils findutils gnugrep gnutar gzip systemd ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = backupScript;
      };
    };
  };

  systemd.timers.minecraft-bedrock-backup = {
    description = "Back up inactive Minecraft Bedrock worlds";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 00/2:00:00";
      Persistent = true;
      RandomizedDelaySec = "5m";
    };
  };
}
