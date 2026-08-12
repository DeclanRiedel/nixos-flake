{ pkgs, pkgsCodex, ... }:

{
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

    # Nix development tooling
    nixd
    nil
    nixpkgs-fmt
    alejandra
    deadnix
    statix

    # AI command-line tools
    pkgsCodex.opencode
    pkgsCodex.codex
    pkgsCodex.claude-code

    bitwarden-cli
  ];
}
