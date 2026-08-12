{ config, hostConfig, inputs, lib, pkgs, ... }:

let
  isWsl = hostConfig.hostName == "nixos-wsl";
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
  ] ++ lib.optionals (!isWsl) [
    ./hyprlock.nix
    ./hypridle.nix
    ./hyprpaper.nix
    ./hyprland.nix
    ./cursor.nix
    ./waybar.nix
    ./swaync.nix
    ./fuzzel.nix
    ./ghostty.nix
    ./zed.nix
    ./floorp.nix
    ./zathura.nix
    ./spotifyd.nix
  ];

  # Newer stylix also sets gtk4.theme.package; force ours to resolve the clash.
  gtk.gtk4.theme = lib.mkIf (!isWsl) (lib.mkForce config.gtk.theme);

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
