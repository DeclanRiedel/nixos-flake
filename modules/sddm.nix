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
          background =
            ../wall/1365923-hd-comic-book-wallpapers-1920x1080-for-mobile.jpg;
        };
      })
    ];

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
