{ pkgs, ... }:

{
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn
  ];

  programs.wireshark = {
    enable = true;
    dumpcap.enable = true;
  };

  environment.systemPackages = with pkgs; [
    wireguard-tools
    openvpn
  ];
}
