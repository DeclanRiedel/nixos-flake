{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bitwarden-cli
    bitwarden-desktop
    vesktop
    obsidian
  ];
}
