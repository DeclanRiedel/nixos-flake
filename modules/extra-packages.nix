{ lib, pkgs, ... }: {

  ## thunar

  programs.chromium.enable =
    lib.mkForce false; # stylix has this enabled by default
  programs.thunar.enable = true;
  programs.xfconf.enable = true;
  services.tumbler.enable = true;
  services.gvfs.enable = true;

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  environment.systemPackages = with pkgs; [
    vscode-fhs
    floorp
    code-cursor
    yt-dlp
    socat
    jq
    atomicparsley
    git-lfs

    blender
    unityhub
    gimp

    networkmanagerapplet
    zellij
    stacer
    btop
    fcitx5
    kodi
    #betterbird
    flameshot
    bitwarden-cli
    bitwarden-desktop
    audacity
    discord
    webcord # better vc
    fractal
    discord-screenaudio # working screenshare
    steam
    xwaylandvideobridge # if discord-screenaudio not work
    obsidian
    waydroid
    #appimage-run
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
