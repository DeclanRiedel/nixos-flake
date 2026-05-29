{ lib, pkgs, pkgsCodex, ... }:

let
  opencodeLatest = import ../../pkgs/opencode-latest.nix { inherit lib pkgs; };
in
{
  imports = [
    ../../modules/zsh.nix
    ../../modules/user-settings.nix
    ../../modules/tmux.nix
  ];

  system.stateVersion = "25.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.hostName = lib.mkForce "nixos-wsl";

  wsl = {
    enable = true;
    defaultUser = "declan";
    useWindowsDriver = true;
    startMenuLaunchers = false;
    wslConf = {
      boot.systemd = true;
      interop = {
        enabled = true;
        appendWindowsPath = true;
      };
      automount = {
        enabled = true;
        root = "/mnt";
        options = "metadata,uid=1000,gid=100";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    pkgsCodex.codex
    opencodeLatest
    gemini-cli

    neovim
    git
    git-lfs
    gh
    lazygit
    diff-so-fancy
    tmux
    just

    ripgrep
    fd
    fzf
    jq
    yq
    bat
    eza
    zoxide
    direnv
    nix-direnv

    nixd
    nil
    nixpkgs-fmt
    alejandra
    deadnix
    statix

    httpie
    wget
    curl
    socat
    rsync
    unzip
    zip

    btop
    procs
    ncdu
    dust
    tldr
    fastfetch
    hyperfine

    dotnet-sdk_9
    jdk17
    docker-client
  ];

  environment.sessionVariables = {
    DOTNET_ROOT = "${pkgs.dotnet-sdk_9.unwrapped}/share/dotnet";
    JAVA_HOME = pkgs.jdk17.home;
  };

  services.openssh.enable = true;
  programs.ssh.startAgent = true;

  users.users.declan.linger = true;
  users.users.root.shell = pkgs.zsh;
}
