{ pkgs, ... }:

{
  environment.systemPackages = [
    # Chili login theme: https://store.kde.org/p/1214121
    (pkgs.sddm-chili-theme.override {
      themeConfig = {
        ScreenWidth = 1920;
        ScreenHeight = 1080;
        blur = true;
        recursiveBlurLoops = 4;
        recursiveBlurRadius = 12;
        background = ../wall/sddm-wall.jpg;
        PasswordFieldOutlined = true;
        AvatarPixelSize = 148;
        FontPointSize = 16;
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
    install -d -m 0755 /var/lib/AccountsService/users

    for user in /home/*; do
      username=$(basename "$user")
      icon_source="$user/.face.icon"
      icon_dest="/var/lib/AccountsService/icons/$username"
      user_dest="/var/lib/AccountsService/users/$username"

      if [ -f "$icon_source" ]; then
        if [ ! -f "$icon_dest" ] || ! cmp -s "$icon_source" "$icon_dest"; then
          rm -f "$icon_dest"
          cp -L "$icon_source" "$icon_dest"
          chmod 0644 "$icon_dest"
        fi

        printf '[User]\nIcon=%s\n' "$icon_dest" > "$user_dest"
        chmod 0644 "$user_dest"
      fi
    done
  '';

  systemd.tmpfiles.rules = [
    "d /var/lib/AccountsService/icons 0755 root root -"
    "d /var/lib/AccountsService/users 0755 root root -"
  ];

  systemd.services.sddm = {
    after = [ "systemd-tmpfiles-setup.service" ];
  };
}
