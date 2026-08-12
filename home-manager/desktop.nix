{ config, lib, pkgs, ... }:

{
  imports = [
    ./home.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./hyprpaper.nix
    ./hyprland.nix
    ./cursor.nix
    ./waybar.nix
    ./swaync.nix
    ./fuzzel.nix
    ./ghostty.nix
    ./zed.nix
    ./floorp.nix
    ./zathura.nix
    ./spotifyd.nix
  ];

  # Newer Stylix also sets gtk4.theme.package; force ours to resolve the clash.
  gtk.gtk4.theme = lib.mkForce config.gtk.theme;

  systemd.user.services.mpris-proxy = {
    Unit.Description = "mpris-proxy";
    Unit.After = [ "network.target" "sound.target" ];
    Service.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
    Install.WantedBy = [ "default.target" ];
  };
}
