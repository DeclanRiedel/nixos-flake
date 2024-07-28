{
  stylix.enable = true;
  stylix.autoEnable = true;

  stylix.base16Scheme = {
    base00 = "000000"; # Pitch black
    base01 = "333333"; # Slightly lighter black
    base02 = "555555"; # Medium gray
    base03 = "777777"; # Slightly darker gray
    base04 = "bbbbbb"; # Light gray
    base05 = "dddddd"; # Slightly lighter gray
    base06 = "bbbbbb"; # Light gray
    base07 = "ffffff"; # White
    base08 = "ff6666"; # Vibrant red
    base09 = "ffaa33"; # Vibrant orange
    base0A = "ffaa33"; # Vibrant orange
    base0B = "99ff33"; # Vibrant green
    base0C = "33ffff"; # Vibrant cyan
    base0D = "33aaff"; # Vibrant blue
    base0E = "cc66ff"; # Vibrant purple
    base0F = "ff9999"; # Vibrant reddish-brown

  };

  stylix.image =
      ../_wall/legoarkhambatman-flipped.jpg;

  stylix.targets.nixvim = {
    enable = false;
    #transparent_bg.main = true;
    #transparent_bg.sign_column = true;
  };

  stylix.targets.lightdm = { enable = true; };

  #plymouth - but do i even want it?
  #stylix.targets.plymouth = {
  #  enable = true;
  #logo = "";
  #logoAnimated = true;
  #};

  stylix.polarity = "dark";

}
