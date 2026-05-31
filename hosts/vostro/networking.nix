{ pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 3000 5173 ];

  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn
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
