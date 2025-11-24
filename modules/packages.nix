{ pkgs, lib, ... }: {
  ##########################################################
  ##  Core Packages that I rely on, more or less          ##
  ##########################################################

 nixpkgs.config = { allowUnfree = true;};

  programs.hyprland.enable = true;

  # settings
  environment.sessionVariables.NIXOS_OZONE_WL =
    "1"; # hints electron to use wayland

  # if above doesn't work:   environment.sessionVariables.ELECTRON_OZONE_PLATFORM_HINT = "auto";

  # idk what to label this section but I'm sure more will be added.
  programs.seahorse.enable = true; # pick between above and gnome-keyring
  #programs.nixvim.enable = true;

  ##########################################################
  ##  Extra Packages                                      ##
  ##########################################################

  # force disable chromium
  programs.chromium.enable =
    lib.mkForce false; # stylix has this enabled by default

  ## thunar filemanager
  programs.thunar.enable = true;
  programs.xfconf.enable = true;
  services.tumbler.enable = true;
  services.gvfs.enable = true;

  #idk what this is below
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  environment.systemPackages = with pkgs; [
    ##########################################################
    ##  Core Packages                                       ##
    ##########################################################
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

    ##########################################################
    ##  Extra Packages                                      ##
    ##########################################################
    # notifications
    dunst
    libnotify
    eww
    # logout menu (i don't even use this its just for rice)
    wlogout

    # spotify probably only subscription that deserves to be paid
    mpv
    spotify
    spotify-player
    spotify-cli-linux
    #cmus
    vlc
    ffmpeg
    atomicparsley

    cheese # webcam camera app
    swappy # ss editor (macos snappy clone)

    #gammastep #time based brightness

    # browsers
    floorp
    gemini-cli
    ## for development
    firefox-devedition
    #chromium force enabled by stylix (manual override top of file)
    #safari
    #microsoft-edge
    #vieb #too unsafe for nixos lmao

    #dropbox #no longer use but its good

    #monitoring shit
    glances
    gping # graph version of ping
    hyperfine
    btop # i like most
    cpufetch
    fastfetch
    speedtest-cli

    #git extra shit
    lazygit
    diff-so-fancy # delta?
    git-lfs

    #editors
    vscode-fhs
    #jetbrains.pycharm-community
    #zed-editor-fhs
    code-cursor
    #windsurf
    
    ### WORK STUFF
    jetbrains.rider
    dotnet-sdk_9

    #gamdev related
    #unityhub
    #godot_4
    #material-maker
    blender

    #apps
    audacity
    gimp
    inkscape
    krita
    mailspring

    ## vm & containers
    #distrobox
    #distrobox-tui
    #podman
    #podman-tui
    docker
    #waydroid

    #extra-utils
    yt-dlp
    gh
    hexyl
    ncdu # replaces du (interactive)
    dust # replaces du
    #zellij - prefer tmux
    #stacer
    fcitx5
    bitwarden-cli
    bitwarden-desktop
    gnome-disk-utility

    # like a 'better' nmtui
    networkmanagerapplet

    #discord: they all fucking suck on wayland, either vc doesnt work or screenshare doesn't work
    vesktop # supposed best discord client + working screenshare for wayland
    #discord
    #webcord
    #discord-screenaudio
    #xwaylandvideobridge #for discord but i dont think maintained

    fractal
    #betterbird #email, i dont use
    whatsapp-for-linux

    #notes
    obsidian
    lorien

    #appimage-run #what is correct way to do this?

    qbittorrent-enhanced

    ## MISC
    #steam
    texliveFull
    dpkg # .deb pkg thing that apt is a frontend for
  ];
  #++ (with inputs; [     #hyprcursor theme
  #rose-pine-hyprcursor.packages.${pkgs.system}.default
  #]); ##could use libmkif but this is fine, although weird since no other inputs.
}
