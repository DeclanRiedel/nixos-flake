{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "declan";
  home.homeDirectory = "/home/declan";
  home.stateVersion = "24.05"; # dont touch !!! 

  home.packages = with pkgs; [
    fastfetch
  ];

  home.file = {
  };
  
  ##bash 
  programs.bash = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    history = {
      expireDuplicatesFirst = true;
      extended = true;
    };
  };
  

  ## starship 
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = pkgs.lib.importTOML ./configs/starship.toml;
  };


  home.sessionVariables = {
     EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
