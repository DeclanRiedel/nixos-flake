{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  system.stateVersion = "24.05"; # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
