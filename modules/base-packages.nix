{ pkgs, ... }: {
  ##########################################################
  ##  Core Packages that I rely on, more or less          ##
  ##########################################################

  programs.hyprland.enable = true;

  # settings
  environment.sessionVariables.NIXOS_OZONE_WL =
    "1"; # hints electron to use wayland

  # if above doesn't work:   environment.sessionVariables.ELECTRON_OZONE_PLATFORM_HINT = "auto";

  # idk what to label this section but I'm sure more will be added.
  programs.seahorse.enable = true; # pick between above and gnome-keyring
  #programs.nixvim.enable = true;

  environment.systemPackages = with pkgs; [
    neovim # doesn't nixvim install it?
    ghostty
    udiskie
    # probably needed
    xwayland
    waypipe
    wlroots
    wayvnc # so shit tbh but idk of an alt

    # clipboard
    wl-clipboard
    wl-clip-persist
    clipman # clipboard manager for wl-clipboard
    cliphist # clipboard history
    #screen capture
    wl-screenrec
    imv # cli img viewers # does ghostty handle for me?

    #audio
    pavucontrol
    pamixer
    playerctl

    #Hypr-ecosystem
    #hyprpanel - maybe better than waybar?
    hyprshot
    hyprpicker
    hyprpaper # replace swww
    hyprshade # supposed to replace gammastep?
    hyprutils

    ranger # fileman > yazi & others #i think yazi has oil.nvim integration? idk might switch if it's actually better
    zathura
    brightnessctl

    fuzzel # nicer rofi - find one that luanches to browser cause those are kinda cool

    nh # nix-helper

    #useful utils
    ripgrep
    httpie # replaces curl
    wget
    pandoc # document converter

    # test
    doppler
    direnv
    # ^^^
    fd
    fzf
    socat # SOcket Cat
    yq # jq for yaml/toml etc
    jq # json query
    git # +lazygit +diff-so-fancy
    unzip
    man
    tldr # show cmd use cases instead of man
    procs # replaces ps
    zoxide # replace cd
    scc # code counter & runtime estimator
    eza # replaces lsd since its faster and can sort file names case-sensitively
    bat # better cat
    rm-improved # rip?
  ];
}

