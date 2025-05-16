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
}
