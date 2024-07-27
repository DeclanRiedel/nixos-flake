{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "declan";
  home.homeDirectory = "/home/declan";
  home.stateVersion = "24.05"; # dont touch !!!
  
  home.packages = with pkgs; [ fastfetch ];

  #  programs.ranger = {
  #  enable = true;
  #  extraConfig = " set preview_images true \n set preview_images_method kitty "; # formatting matters
  #};

  home.file = { };

  ##bash 
  programs.bash = { enable = true; };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    history = {
      expireDuplicatesFirst = true;
      extended = true;
    };
  };
  ##kitty
  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 2;
      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0;
    };
  };

  ## starship 
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
      enableBashIntegration = true;
    settings = pkgs.lib.importTOML ./configs/starship.toml;
  };

  home.sessionVariables = { EDITOR = "nvim"; };

  programs.home-manager.enable = true;
}
