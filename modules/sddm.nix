{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs;
    [
      (sddm-chili-theme.override {
        themeConfig = {
          ScreenWidth = 1920;
          ScreenHeight = 1080;
          blur = true;
          recursiveBlurLoops = 5;
          recursiveBlurRadius = 5;
          background = ../wall/sddm-wall.jpg;
        };
      })
    ];

  environment.etc."wayland-sessions/Hyprland.desktop".text = ''
    [Desktop Entry]
    Name=Hyprland
    Comment=Tiling wayland compositor
    Exec="Hyprland"
    Type=Application"
    Keywords=wm;tiling
  '';

  services.displayManager = {
    # startx.enable = false;

    sddm = {
      enable = true;
      settings = {
        #Theme = {
        #  FacesDir =
        #    "/home/declan/.dotfiles/nixos-flake/wall/faces"; # what the fuck??
        #};
      };
      wayland.enable = true;
      theme = "chili";
    };
  };

# Define systemd service to run on boot to load avatars for sddm
    systemd.services."sddm-avatar" = {
      description = "Service to copy or update users Avatars at startup.";
      wantedBy = [ "multi-user.target" ];
      before = [ "sddm.service" ];
      script = ''
        set -eu
        for user in /home/*; do
            username=$(basename "$user")
            if [ -f "$user/.face.icon" ]; then
                if [ ! -f "/var/lib/AccountsService/icons/$username" ]; then
                    cp "$user/.face.icon" "/var/lib/AccountsService/icons/$username"
                else
                    if [ "$user/.face.icon" -nt "/var/lib/AccountsService/icons/$username" ]; then
                        cp "$user/.face.icon" "/var/lib/AccountsService/icons/$username"
                    fi
                fi
            fi
        done
      '';
      serviceConfig = {
        Type = "simple";
        User = "root";
        StandardOutput = "journal+console";
        StandardError = "journal+console";
      };
    };

    # # Ensures SDDM starts after the service.
    systemd.services.sddm = { after = [ "sddm-avatar.service" ]; };
  }
