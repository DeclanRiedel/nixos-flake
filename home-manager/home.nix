{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  home.username = "declan";
  home.homeDirectory = "/home/declan";
  home.stateVersion = "24.05"; # dont touch !!!

  home.packages = with pkgs; [ fastfetch ];

  imports = [
    ./zsh.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./hyprland.nix
    ./waybar.nix
    ./fuzzel.nix
    # ./tmux.nix
  ];

  systemd.user.services.mpris-proxy = {
    Unit.Description = "mpris-proxy";
    Unit.After = [ "network.target" "sound.target" ];
    Service.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
    Install.WantedBy = [ "default.target" ];
  }; # blueooth audio buttons

  programs.ranger = {
    enable = true;
    extraConfig =
      " set preview_images true \n set preview_images_method kitty "; # formatting matters
  };

  ##bash 
  programs.bash = { enable = true; };

  #zsh - history + starship (doesnt conflict with zsh.nix)
  programs.zsh = {
    enable = true;
    history = { extended = true; };
    enableCompletion = true;
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
    settings = pkgs.lib.importTOML ../config/starship.toml;
  };

  home.sessionVariables = { EDITOR = "nvim"; };

  programs.home-manager.enable = true;
}
