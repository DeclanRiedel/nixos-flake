{ pkgs, ... }:

{
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
