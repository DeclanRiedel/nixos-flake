{ pkgs, ... }: {
##Display Manager

services.displayManager.sddm = {
  enable = true;
  theme = "";
  #/run/current-system/sw/shares/sddm/themes
  #/run/current-system/sw/shares/sddn/faces
  #$out/share/sddm/faces,themes call theme from cfg.theme if in environment.systempackages
#background & face
};

programs.hyprland = {
  enable = true;
  };

programs.waybar = {
  enable = true;
};

}


