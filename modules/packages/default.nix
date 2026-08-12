{ pkgs, pkgsCodex, ... }:

let
  prince = pkgs.callPackage ../../pkgs/prince.nix { };
in
{
  environment.sessionVariables = {
    DOTNET_ROOT = "${pkgs.dotnet-sdk_9.unwrapped}/share/dotnet";
    JAVA_HOME = pkgs.jdk17.home;
  };

  environment.systemPackages = with pkgs; [
    # Shell and everyday terminal tools
    vim
    nh
    git
    git-lfs
    lazygit
    diff-so-fancy
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
    just
    httpie
    wget
    socat
    unzip
    tldr
    procs
    rm-improved

    # Documents, inspection, and system utilities
    pandoc
    doppler
    scc
    gping
    hyperfine
    btop
    speedtest-cli
    yt-dlp
    hexyl
    dust
    dpkg

    # Development runtimes and tooling
    nodejs_24
    python3
    gnumake
    gcc
    dotnet-sdk_9
    jdk17
    nixd
    nil
    nixpkgs-fmt
    alejandra
    deadnix
    statix
    gemini-cli
    prince

    # AI command-line tools
    pkgsCodex.opencode
    pkgsCodex.codex
    pkgsCodex.claude-code

    bitwarden-cli
  ];
}
