{ pkgs, ... }: {
  ##zsh also defined as hm module
  programs = {
    zsh = {
      enable = true;
      zsh-autoenv.enable = true;
      syntaxHighlighting.enable = true;
      ohMyZsh = {
        enable = true;
        plugins = [ "git" "history" ];
      };
    };
  };

  programs.hyprland.enable = true;

  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;


  ##system base packages - unfree from flake or defualt.nix?
  environment.systemPackages = with pkgs; [
    neovim
    dunst
    #writeshellscriptbin

    #logout screensaver
    wlogout
    #
    pavucontrol
    pamixer

    #clipboard 
    wl-clipboard
    clipman
    cliphist
    wl-clip-persist

    wl-screenrec
    grim # screenshot tool
    slurp # define grim ss size
    swappy # screenshot editor

    ##hypr
    hyprpicker
    # hypridle
    #hyprlock
    hyprshot
    hyprpaper
    hyprshade
    hyprutils
    hyperfine

    mpv
    imv

    ranger
    #lf
    #ueberzug # help display img?
    zathura

    ##kinda ricing?
    gammastep # weird config
    #libnotify # -> daemon sup eww?
    brightnessctl
    swww
    kitty
    #eww
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
