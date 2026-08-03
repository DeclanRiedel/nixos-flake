{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    ghostty
    brightnessctl
    fuzzel
    nh

    ripgrep
    httpie
    wget
    pandoc
    doppler
    direnv
    fd
    fzf
    socat
    yq
    jq
    git
    unzip
    man
    tldr
    procs
    zoxide
    scc
    eza
    bat
    rm-improved

    glances
    gping
    hyperfine
    btop
    cpufetch
    fastfetch
    speedtest-cli
    yt-dlp
    gh
    hexyl
    ncdu
    dust
    fcitx5
    gnome-disk-utility
    dpkg

    nodejs_24
    python3
    gnumake
    gcc
  ];
}
