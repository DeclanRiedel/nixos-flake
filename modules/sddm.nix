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

  # Define systemd service to run on boot
  systemd.services."sddm-avatar" = {
    description = "Service to copy or update users Avatars at startup.";
    wantedBy = [ "multi-user.target" ];
    before = [ "sddm.service" ];
    script = ''
      for user in /home/*; do

        username=$(basename "$user")
        icon_source="$user/.face.icon"
        icon_dest="/var/lib/AccountsService/icons/$username"

        if [ -f "$icon_source" ]; then
          if [ ! -f "$icon_dest" ] || ! cmp -s "$icon_source" "$icon_dest"; then
            rm -f "$icon_dest"
            cp -L "$icon_source" "$icon_dest"
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

  # Ensures SDDM starts after the service.
  systemd.services.sddm = { after = [ "sddm-avatar.service" ]; };

}
