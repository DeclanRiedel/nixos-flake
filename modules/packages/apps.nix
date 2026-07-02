{ pkgs, pkgsStable, ... }:

{
  environment.systemPackages = with pkgs; [
    bitwarden-cli
    telegram-desktop
    pkgsStable.bitwarden-desktop
    vesktop
    obsidian
  ];
}
