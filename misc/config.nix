{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  #here because merge error that doesnt make sense when importing into default.nix????? 
  virtualisation.docker.enable = true;

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    #default /var/lib/postgresql/16

    ensureDatabases = [ "container-forms" "valid-users" ];
    ensureUsers = [
      { name = "declan"; }
      #{
      #  name = "container-forms";
      #  ensureDBOwnership = true;
      #}
    ];
  };

  system.stateVersion = "24.05"; # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
