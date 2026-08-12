{ hostConfig, inputs, pkgs, pkgsCodex, ... }:

{
  imports = [
    inputs.nixos-wsl.nixosModules.default
    ../../modules/zsh.nix
    ../../modules/user-settings.nix
    ../../modules/tmux.nix
    ../../modules/ai-auto-update.nix
  ];

  system.stateVersion = "25.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  wsl = {
    enable = true;
    defaultUser = hostConfig.user.name;
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
    pkgsCodex.opencode
    pkgsCodex.claude-code
    gemini-cli

    git
    git-lfs
    lazygit
    diff-so-fancy
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
    hyperfine

    docker-client
  ];

  services.openssh.enable = true;

  users.users.${hostConfig.user.name}.linger = true;
  users.users.root.shell = pkgs.zsh;
}
