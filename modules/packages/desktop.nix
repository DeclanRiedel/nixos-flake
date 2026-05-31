{ pkgs, lib, ... }:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
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
    udiskie
    xwayland
    waypipe
    wlroots
    wayvnc

    wl-clipboard
    wl-clip-persist
    clipman
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
    hyprutils
    uwsm

    libnotify
    eww
    wlogout

    cheese
    swappy
    floorp-bin
    firefox-devedition
    networkmanagerapplet
  ];
}
