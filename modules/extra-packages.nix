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

    yt-dlp
    socat
    jq

    blender
    unityhub
    gimp

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
    steam
    xwaylandvideobridge # if discord-screenaudio not work
    obsidian
    waydroid
    appimage-run
    qbittorrent-enhanced
    lorien
    gnome-disk-utility
    cmus
    #music-player
    vlc
    dpkg
    whatsapp-for-linux
    texliveFull
  ];
}
