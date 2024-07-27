{ lib, nixpkgs, ... }: {
  nixpkgs.config.allowUnfree = lib.mkForce true;

  #systemd bootloader 
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 2;
    systemd-boot.configurationLimit = lib.mkDefault 8;
  };

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

  services.xserver.enable = true; # ??? why ???

  ## sound

  #sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
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

  #system = {
  #autoUpgrade = {
  #  enable = true;
  #  operation = "boot";
  #  flake = "~/.dotfiles";
  #dates = "weekly";
  #channels?
  #};

  #};
  #}
}
