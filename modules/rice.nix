{ pkgs, ... }: {
  ##Display Manager
  environment.systemPackages = with pkgs; [ sddm-chili-theme where-is-my-sddm-theme ];

  services.displayManager.sddm = {
    enable = true;
    theme = "chili";
    settings.theme = {
      #      faces 
    };
  };

  programs.waybar.enable = true;

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

  programs.hyprland = { enable = true; };

}
