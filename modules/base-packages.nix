{ pkgs, ... }: {
  programs.hyprland.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  #gnome key managers
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  environment.systemPackages = with pkgs; [
    neovim

    #notifications
    dunst
    libnotify
    eww
    xwayland

    #ricing
    wlogout

    #sound
    pavucontrol
    pamixer
    playerctl
    mpv

    #disk
    udiskie

    #clipboard 
    wl-clipboard
    clipman
    cliphist
    wl-clip-persist

    #screencapture
    wl-screenrec
    grim # screenshot tool
    slurp # define grim ss size
    swappy # screenshot editor
    cheese # webcam app
    imv # img viewer

    ##hypr
    hyprpicker
    hyprshot
    hyprpaper
    hyprshade
    hyprutils
    hyperfine

    #filemanager
    ranger

    #pdf viewer
    zathura

    #brightness
    gammastep # weird config
    brightnessctl

    #wallpaper
    swww

    #terminal
    kitty

    #app launcher
    fuzzel

    #fuck dropbox
    dropbox
    firefox

    #nixhelper
    nh

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
