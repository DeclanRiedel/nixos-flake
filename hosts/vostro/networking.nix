{ config, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 443 80 3000 5173 ];
  networking.firewall.allowedUDPPorts = [ 51820 ];

  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn
  ];

  networking.wireguard.interfaces.wg0 = {
    ips = [ "192.168.48.1/24" ];
    listenPort = 51820;
    privateKeyFile = config.sops.secrets."wireguard-private-key".path;

    postSetup = ''
      ${pkgs.openresolv}/bin/resolvconf -a wg0 -m 0 <<< "nameserver 192.168.48.1"
    '';

    postShutdown = ''
      ${pkgs.openresolv}/bin/resolvconf -d wg0
    '';

    peers = [
      {
        publicKey = "SL8XRNCJc4iKT3VE2p7zwoL0+FPKMS+dJzaWGvjeozE=";
        allowedIPs = [ "0.0.0.0/0" "::/0" ];
      }
    ];
  };

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
