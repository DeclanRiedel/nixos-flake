{ pkgs, ... }: {
  ## sddm but it sometimes doesnt start hyprland or makes me enter passwd twice

  #environment.systemPackages = with pkgs; [ sddm-chili-theme where-is-my-sddm-theme ];
  # services.displayManager.sddm = {
  #  enable = true;
  #  theme = "chili";
  #  settings.theme = {
  #    #      faces 
  #  };
  #};

  services.xserver.displayManager.lightdm.greeters.slick.enable = true;

  #hypr stuff
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  programs.waybar.enable =
    true; # copy of config inside ../home-manager/configs/waybar

  #services.displayManager.sddm = {
  # enable = true;
  #theme = "";
  #/run/current-system/sw/shares/sddm/themes
  #/run/current-system/sw/shares/sddn/faces
  #$out/share/sddm/faces,themes call theme from cfg.theme if in environment.systempackages
  #background & face
  #};

  #services.xserver.displayManager = {
  #autoLogin.enable = true;
  #autoLogin.user = "declan";
  #gdm = {
  #     enable = true;
  #   wayland = true;
  #autoLogin.enable = true;
  # };
  #};

}
