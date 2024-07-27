{ pkgs, ... }: {
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

  ##system base packages - unfree from flake or defualt.nix?
  environment.systemPackages = with pkgs; [
    neovim
    #writeshellscriptbin

    #logout screensaver
    wlogout

    #clipboard 
    wl-clipboard
    cliphist
    wl-clip-persist

    wl-screenrec
    grim # screenshot tool
    slurp # define grim ss size
    swappy # screenshot editor
    hyprpicker # colorpicker

    mpv
    imv

    ranger
    lf
    ueberzug # help display img?
    zathura

    ##kinda ricing?
    gammastep # weird config
    libnotify # -> daemon sup eww?
    hyprpaper # -> config under hyprland somehow
    brightnessctl
    swww
    kitty
    eww
    wofi # rofi? dmenu my pref?
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
