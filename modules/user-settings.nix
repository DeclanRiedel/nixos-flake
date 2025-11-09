{ pkgs, ... }: {
  users.users.declan = {
    isNormalUser = true;
    home = "/home/declan";
    extraGroups = [ "wheel" "networkmanager" ];
    uid = 1000;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB36tS6T6hOQ+PlarOlfrF2uwbsSMD9EOBr5KpUo5Bay declan.riedel@protonmail.com" ];
  };

  time.timeZone = "Africa/Windhoek";
  #services.automatic-timezoned.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    #keyMap = "us";
    useXkbConfig = true; # xkb.options in tty
  };

}
