{ hostConfig, inputs, pkgs, ... }:

let
  flakeDir = "${hostConfig.user.home}/.nixos";
in
{
  home.username = hostConfig.user.name;
  home.homeDirectory = hostConfig.user.home;
  home.stateVersion = "24.05";

  home.packages = [
    pkgs.fastfetch
    inputs.zed-thread-tui.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  imports = [
    ./zsh.nix
    ./ranger.nix
    ./yazi.nix
  ];

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
      cc = "claude --dangerously-skip-permissions";
      codex = "codex --yolo";
      ranger = "y";
      switch = "${flakeDir}/scripts/switch.sh";
      update-ai = "cd ${flakeDir} && nix flake update nixpkgs-codex && ${flakeDir}/scripts/switch.sh";
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
    nixpkgs.source = inputs.nixpkgs;
    imports = [ ../nixvim/config/default.nix ];
  };
}
