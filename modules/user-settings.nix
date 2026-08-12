{ hostConfig, pkgs, sshKeys, ... }: {
  users.users.${hostConfig.user.name} = {
    isNormalUser = true;
    home = hostConfig.user.home;
    uid = 1000;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [ sshKeys.personal ];
  };

  programs.ssh.startAgent = true;

  time.timeZone = "Africa/Windhoek";
  #services.automatic-timezoned.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    #keyMap = "us";
    useXkbConfig = true; # xkb.options in tty
  };

}
