{ pkgs, ... }:

{
  services.displayManager.defaultSession = "hyprland";

  services.greetd = {
    enable = true;
    greeterManagesPlymouth = true;
  };

  programs.regreet = {
    enable = true;

    theme = {
      package = pkgs.gnome-themes-extra;
      name = "Adwaita-dark";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font";
      size = 14;
    };

    settings = {
      background = {
        path = ../wall/sddm-wall.jpg;
        fit = "Cover";
      };

      appearance.greeting_msg = "Welcome back";

      GTK = {
        application_prefer_dark_theme = true;
      };

      commands = {
        reboot = [ "systemctl" "reboot" ];
        poweroff = [ "systemctl" "poweroff" ];
      };

      widget.clock = {
        format = "%a %H:%M";
        resolution = "500ms";
      };
    };

    extraCss = ''
      window {
        background: transparent;
      }

      box {
        border-radius: 8px;
      }

      entry,
      button,
      combobox {
        border-radius: 6px;
      }
    '';
  };
}
