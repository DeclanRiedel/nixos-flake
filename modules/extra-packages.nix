{ lib, pkgs, ... }: {

  ## thunar

  programs.chromium.enable =
    lib.mkForce false; # stylix has this enabled by default
  programs.thunar.enable = true;
  programs.xfconf.enable = true;
  services.tumbler.enable = true;
  services.gvfs.enable = true;

  environment.systemPackages = with pkgs; [
    vscode-fhs
    floorp

    networkmanagerapplet
    zellij
    stacer
    btop
    fcitx5
    kodi
    betterbird
    flameshot
    audacity
    discord
    webcord # better vc
    fractal
    discord-screenaudio # working screenshare

    xwaylandvideobridge # if discord-screenaudio not work
    obsidian
    qbittorrent-enhanced
    lorien
    gnome-disk-utility
    cmus
    music-player
    vlc
    dpkg
    whatsapp-for-linux
    texliveFull
  ];
}
