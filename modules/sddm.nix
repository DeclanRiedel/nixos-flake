{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.sddm-chili-theme.override {
      themeConfig = {
        ScreenWidth = 1920;
        ScreenHeight = 1080;
        blur = false;
        recursiveBlurLoops = 5;
        recursiveBlurRadius = 5;
        background = ../wall/sddm-wall.jpg;
      };
    })
  ];

  services.displayManager = {
    defaultSession = "hyprland";

    sddm = {
      enable = true;
      wayland.enable = false;
      theme = "chili";
    };
  };

  system.activationScripts.sddm-avatar.text = ''
    install -d -m 0755 /var/lib/AccountsService/icons

    for user in /home/*; do
      username=$(basename "$user")
      icon_source="$user/.face.icon"
      icon_dest="/var/lib/AccountsService/icons/$username"

      if [ -f "$icon_source" ]; then
        if [ ! -f "$icon_dest" ] || ! cmp -s "$icon_source" "$icon_dest"; then
          rm -f "$icon_dest"
          cp -L "$icon_source" "$icon_dest"
          chmod 0644 "$icon_dest"
        fi
      fi
    done
  '';

  systemd.tmpfiles.rules = [
    "d /var/lib/AccountsService/icons 0755 root root -"
  ];

  systemd.services.sddm = {
    after = [ "systemd-tmpfiles-setup.service" ];
  };
}
