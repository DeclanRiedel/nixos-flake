{ lib, pkgs, pkgsStable, ... }:

{
  programs.hyprland = {
    enable = true;
    # uwsm-managed session exits with code 127 under SDDM, bouncing the user
    # back to the greeter. Launch Hyprland directly via its start-hyprland
    # session entry instead (the only wayland session once uwsm is off).
    withUWSM = false;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  programs.seahorse.enable = true;
  programs.chromium.enable = lib.mkForce false;
  programs.thunar.enable = true;
  programs.xfconf.enable = true;
  services.tumbler.enable = true;
  services.gvfs.enable = true;

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  environment.systemPackages = with pkgs; [
    ghostty
    brightnessctl
    fuzzel
    udiskie
    xwayland
    wayvnc

    wl-clipboard
    wl-clip-persist
    cliphist
    wl-screenrec
    imv

    pavucontrol
    pamixer
    playerctl

    hyprshot
    hyprpicker
    hyprpaper
    hyprshade

    libnotify
    wlogout

    cheese
    swappy
    gnome-disk-utility
    fcitx5
    floorp-bin
    firefox-devedition
    networkmanagerapplet

    vscode-fhs
    zed-editor

    telegram-desktop
    pkgsStable.bitwarden-desktop
    vesktop
    obsidian

    mpv
    spotify
    spotify-player
    vlc
    ffmpeg
    atomicparsley
  ];
}
