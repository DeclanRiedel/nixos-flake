{ pkgs, ... }: {
users.users.declan = {
  isNormalUser = true;
  home = "/home/declan";
  extraGroups = [ "wheel" "networkmanager" ];
  uid = 1000;
  shell = pkgs.zsh;
  };

  time.timeZone = "Africa/Windhoek";
  #services.automatic-timezoned.enable = true;

i18n.defaultLocale = "en_US.UTF-8";

console = {
  font = "Lat2-Terminus16";
  #keyMap = "us";
  useXkbConfig = true; #xkb.options in tty
};

}

