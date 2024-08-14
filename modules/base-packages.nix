{ lib, pkgs, ... }: {
  programs.hyprland.enable = true;

  programs.chromium.enable = lib.mkForce false; #stylix has this enabled by default

  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    #dunst
    #writeshellscriptbin
    libnotify
    wlogout
    pavucontrol
    pamixer
    udiskie

    #clipboard 
    wl-clipboard
    clipman
    cliphist
    wl-clip-persist

    wl-screenrec
    grim # screenshot tool
    slurp # define grim ss size
    swappy # screenshot editor
    cheese

    ##hypr
    hyprpicker
    #hypridle
    #hyprlock
    hyprshot
    hyprpaper
    hyprshade
    hyprutils
    hyperfine
    playerctl
    mpv
    imv

    ranger
    zathura

    gammastep # weird config
    #libnotify # -> daemon sup eww?
    brightnessctl
    swww
    kitty
    eww
    fuzzel
    dropbox
    nh
    xwayland

    ## cli tools
    # xdg?

    gnugrep
    ripgrep
    wget
    fzf
    git
    unzip
    w3m-nox
    tldr
    lazygit
    hyperfine
    procs # ps but better
    cht-sh # ??
    gping
    glances
    htop
    zenith
    zoxide
    scc
    thefuck
    eza # ls but better
    duf
    bat
    diff-so-fancy
    rm-improved
    tre-command
    bandwhich
    navi
    ffmpeg
    cpufetch
    lsd
    speedtest-cli
  ];

}
