{ config, lib, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 443 80 3000 5173 ];
  networking.firewall.allowedUDPPorts = [ 51820 ];

  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn
  ];

  # WireGuard VPN client. Does NOT auto-start on boot so it can never
  # take the host offline by itself - toggle it from the Waybar VPN button.
  networking.wireguard.interfaces.wg0 = {
    ips = [ "192.168.48.1/24" ];
    listenPort = 51820;
    privateKeyFile = config.sops.secrets."wireguard-private-key".path;
    # Re-resolve the endpoint periodically so DNS/hostname changes are picked
    # up and the peer keeps retrying instead of failing outright.
    dynamicEndpointRefreshSeconds = 25;

    postSetup = ''
      ${pkgs.openresolv}/bin/resolvconf -a wg0 -m 0 <<< "nameserver 192.168.48.1"
    '';

    postShutdown = ''
      ${pkgs.openresolv}/bin/resolvconf -d wg0
    '';

    peers = [
      {
        publicKey = "SL8XRNCJc4iKT3VE2p7zwoL0+FPKMS+dJzaWGvjeozE=";
        allowedIPs = [ "::/0" ];
        endpoint = "office.revo.in.na:13231";
        persistentKeepalive = 10;
      }
    ];
  };

  # The wireguard module wires wireguard-wg0.target into multi-user.target,
  # which would auto-start the tunnel on every boot. Drop that so the tunnel
  # only comes up when toggled on demand from Waybar.
  systemd.targets."wireguard-wg0".wantedBy = lib.mkForce [ ];

  # Allow declan to toggle the VPN from Waybar without a password prompt.
  # Starting/stopping wireguard-wg0.service brings the peer up and down too,
  # because the peer unit both Requires and is WantedBy the interface service.
  security.sudo.extraRules = [
    {
      users = [ "declan" ];
      commands = [
        { command = "/run/current-system/sw/bin/systemctl start wireguard-wg0.service"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/systemctl stop wireguard-wg0.service"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/systemctl restart wireguard-wg0.service"; options = [ "NOPASSWD" ]; }
      ];
    }
  ];

  programs.wireshark = {
    enable = true;
    dumpcap.enable = true;
  };

  users.users.declan.extraGroups = [ "wireshark" ];

  environment.systemPackages = with pkgs; [
    wireguard-tools
    openvpn
  ];
}
