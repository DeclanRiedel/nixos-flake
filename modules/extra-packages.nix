{ pkgs, lib, ... }: {

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
    #code-cursor
    #windsurf
    #jetbrains.rider

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

    ## vm & containers
    #distrobox
    #distrobox-tui
    #podman
    #podman-tui
    docker
    #waydroid

    #extra-utils
    yt-dlp
    fd
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
