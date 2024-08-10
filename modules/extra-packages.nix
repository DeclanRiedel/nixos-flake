{ pkgs, ... }: {

  ## thunar

  programs.thunar.enable = true;
  programs.xfconf.enable = true;
  services.tumbler.enable = true;
  services.gvfs.enable = true;

  environment.systemPackages = with pkgs; [
    vscode-fhs
    floorp
    networkmanagerapplet
    #discord
    webcord
    fractal
    discord-screenaudio
    #xwaylandvideobridge #if discord-screenaudio not work 
    obsidian
    qbittorrent-enhanced
    lorien
    gnome.gnome-disk-utility
    cmus
    music-player
    vlc
    dpkg
    whatsapp-for-linux
    texliveFull
  ];
}
