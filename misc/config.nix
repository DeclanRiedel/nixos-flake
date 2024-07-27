{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  virtualisation.docker.enable = true;

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    #default /var/lib/postgresql/16

    ensureDatabases = [ "container-forms" "valid-users" ];
    ensureUsers = [{
      name = "declan";
    }
    #{
    #  name = "container-forms";
    #  ensureDBOwnership = true;
    #}
      ];
  };

  stylix.enable = true;
  stylix.autoEnable = true;
  stylix.base16Scheme =
    "${pkgs.base16-schemes}/share/themes/tokyo-night-storm.yaml";
  stylix.image = /home/declan/Media/Pictures/1107977.jpg;

  stylix.targets.nixvim = {
    enable = false;
    #transparent_bg.main = true;
    #transparent_bg.sign_column = true;
  };

  stylix.targets.lightdm = { enable = true; };

  #plymouth???
  #stylix.targets.plymouth = {
  #  enable = true;
  #logo = "";
  #logoAnimated = true;
  #};

  stylix.polarity = "dark";

  #services.mpd = {
    #enable = true;
    #user = "declan";
    #startWhenNeeded = true;
    #playlistDirectory = "/home/declan/Media/Music";
    #muiscDirectory = "/home/declan/Media/Music";
    #};

  #here because merge error that doesnt make sense when importing into default.nix????? 
  system.stateVersion = "24.05"; # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
