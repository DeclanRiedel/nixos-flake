{ lib, nixpkgs, pkgs, ... }: {
  nixpkgs.config.allowUnfree = lib.mkForce true;

  #systemd bootloader 
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 2;
    systemd-boot.configurationLimit = lib.mkDefault 8;
  };

  # services.autofs = {
  #  enable = true;
  #  autoMaster = let
  #mapConf = pkgs.writeText "auto" ''
  # kernel    -ro,soft,intr       ftp.kernel.org:/pub/linux
  # boot      -fstype=ext2        :/dev/hda1
  # windoze   -fstype=smbfs       ://windoze/c
  # removable -fstype=ext2        :/dev/hdd
  # cd        -fstype=iso9660,ro  :/dev/hdc
  # floppy    -fstype=auto        :/dev/fd0
  # server    -rw,hard,intr       / -ro myserver.me.org:/ \
  #                               /usr myserver.me.org:/usr \
  #                               /home myserver.me.org:/home
  #'';
  #in ''
  #/auto file:${mapConf}
  #'';

  #};

  networking = {
    networkmanager.enable = true;
    hostName = "machine";
  };

  ##ssh 
  programs.ssh.startAgent = true;

  ## bluetooth

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  services.xserver.enable = true;

  ## sound

  #sound.enable = true; -deprecated?
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  ## cups for printing
  services.printing.enable = true;

  ## touchpad support? hyprland does it already?
  services.xserver.libinput.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "delete-older-than 14d";
  };

  system = {
    autoUpgrade = {
      enable = true;
      operation = "boot";
      flake = "~/.dotfiles";
      dates = "weekly";
      #channels?
    };

  };
  #}
}
