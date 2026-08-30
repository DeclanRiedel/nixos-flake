{ lib, pkgs, pkgsStable, ... }:

{
  programs.hyprland = {
    enable = true;
    # The UWSM-managed session exits with code 127 under SDDM. Launch
    # Hyprland directly through its start-hyprland session entry.
    withUWSM = false;
  };

  programs.waybar.enable = true;
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # SDDM runs on X11 while the user session runs on Wayland.
  services.xserver.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.printing.enable = true;
  services.libinput.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

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
    impala

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
