{ pkgs, lib, pkgsCodex, ... }:
let
  opencodeLatestVersion = "1.14.48";
  opencodeLatest = pkgs.stdenvNoCC.mkDerivation {
    pname = "opencode";
    version = opencodeLatestVersion;

    src = pkgs.fetchurl {
      url = "https://github.com/anomalyco/opencode/releases/download/v${opencodeLatestVersion}/opencode-linux-x64.tar.gz";
      hash = "sha256-0GEl3gdK+cF75kkTfivvWbd0x2aBMLAIb5vZm6Z7r4I=";
    };

    baselineSrc = pkgs.fetchurl {
      url = "https://github.com/anomalyco/opencode/releases/download/v${opencodeLatestVersion}/opencode-linux-x64-baseline.tar.gz";
      hash = "sha256-14l6eBTGUryTmsVrNRg/lot34zF4p6LX725k6vD3aOQ=";
    };

    dontUnpack = true;
    nativeBuildInputs = with pkgs; [ patchelf ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/lib/opencode/linux-x64 $out/lib/opencode/linux-x64-baseline
      tar -xzf $src -C $out/lib/opencode/linux-x64
      tar -xzf $baselineSrc -C $out/lib/opencode/linux-x64-baseline
      patchelf --set-interpreter ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 $out/lib/opencode/linux-x64/opencode
      patchelf --set-interpreter ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 $out/lib/opencode/linux-x64-baseline/opencode

      cat > $out/bin/opencode <<'EOF'
      #!${pkgs.runtimeShell}
      export PATH=${lib.makeBinPath [ pkgs.ripgrep ]}:$PATH
      if grep -qw avx2 /proc/cpuinfo 2>/dev/null; then
        exec @out@/lib/opencode/linux-x64/opencode "$@"
      fi
      exec @out@/lib/opencode/linux-x64-baseline/opencode "$@"
      EOF
      substituteInPlace $out/bin/opencode --replace-fail @out@ $out
      chmod +x $out/bin/opencode

      runHook postInstall
    '';

    meta = with lib; {
      description = "AI coding agent built for the terminal";
      homepage = "https://opencode.ai";
      license = licenses.mit;
      mainProgram = "opencode";
      platforms = [ "x86_64-linux" ];
    };
  };
in {
  ##########################################################
  ##  Core Packages that I rely on, more or less          ##
  ##########################################################

  programs.hyprland.enable = true;

  # settings
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # hints electron to use wayland
    # Android SDK/emulator images make system rebuilds very large. Re-enable
    # these with the androidSdk package below when Android work is active.
    # ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
    # ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
    DOTNET_ROOT = "${pkgs.dotnet-sdk_9.unwrapped}/share/dotnet";
    JAVA_HOME = pkgs.jdk17.home;
  };

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
    floorp-bin
    gemini-cli
    pkgsCodex.codex
    opencodeLatest
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
    #code-cursor # large Electron editor; keep out of the boot-critical closure
    #windsurf
    
    ### WORK STUFF
    #jetbrains.rider # large proprietary IDE; install ad hoc when needed
    dotnet-sdk_9
    #androidSdk # very large SDK/emulator closure
    #android-tools
    jdk17

    #gamdev related
    #unityhub
    #godot_4
    #material-maker
    #blender # large creative suite; avoid blocking rebuilds

    #apps
    #audacity
    #gimp
    #inkscape # was building locally and blocking nixos-rebuild
    #krita
    #mailspring

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

    #fractal # Rust/GNOME app; was building locally and OOMing
    #betterbird #email, i dont use
    #karere # niche chat app; keep out of base system closure

    #notes
    obsidian
    #lorien # old/niche drawing app; install ad hoc if needed

    #appimage-run #what is correct way to do this?

    #qbittorrent-enhanced # niche variant; use normal qbittorrent if needed

    ## MISC
    #steam
    #texliveFull
    dpkg # .deb pkg thing that apt is a frontend for
  ];
  #++ (with inputs; [     #hyprcursor theme
  #rose-pine-hyprcursor.packages.${pkgs.system}.default
  #]); ##could use libmkif but this is fine, although weird since no other inputs.
}
