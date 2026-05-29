{ config, inputs, pkgs, ... }:

{
  home.username = "declan";
  home.homeDirectory = "/home/declan";
  home.stateVersion = "24.05";

  home.packages = [
    pkgs.fastfetch
    inputs.zed-thread-tui.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  gtk.gtk4.theme = config.gtk.theme;

  imports = [
    ./zsh.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./hyprpaper.nix
    ./hyprland.nix
    ./waybar.nix
    ./swaync.nix
    ./fuzzel.nix
    ./ghostty.nix
    ./zed.nix
    ./floorp.nix
    ./zathura.nix
    ./ranger.nix
    ./yazi.nix
  ];

  systemd.user.services.mpris-proxy = {
    Unit.Description = "mpris-proxy";
    Unit.After = [ "network.target" "sound.target" ];
    Service.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
    Install.WantedBy = [ "default.target" ];
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Declan Riedel";
        email = "declan.riedel@protonmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = false;
      push.autoSetupRemote = true;
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };

  programs.bash = { enable = true; };

  programs.zsh = {
    enable = true;
    history.extended = true;
    enableCompletion = true;
    shellAliases = {
      codex = "codex --yolo";
      ranger = "y";
      yazi = "y";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = pkgs.lib.importTOML ../config/starship.toml;
  };

  programs.worktrunk = {
    enable = true;
    enableZshIntegration = true;
    package = inputs.worktrunk.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (_old: {
      cargoArtifacts = null;
    });
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    SHELL = "zsh";
  };

  programs.home-manager.enable = true;

  programs.nixvim = {
    enable = true;
    imports = [ ../nixvim/config/default.nix ];
  };
}
