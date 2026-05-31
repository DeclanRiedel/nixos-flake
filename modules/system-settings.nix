{ lib, pkgs, ... }: {

  #systemd bootloader 
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 2;
    systemd-boot.configurationLimit = lib.mkDefault 6;
  };

  networking = {
    networkmanager.enable = true;
    hostName = "machine";
  };

  ##ssh 
  programs.ssh.startAgent = true;
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      X11Forwarding = true;
      PermitRootLogin = "no";
    };
  };

  ## bluetooth

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  services.xserver.enable = true; # xorg

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
  services.libinput.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
  };

  systemd.services.nix-gc.preStart = ''
    ${pkgs.nix}/bin/nix-env --profile /nix/var/nix/profiles/system --delete-generations +6
  '';

  system = {
    autoUpgrade = {
      enable = true;
      operation = "boot";
      flake = "github:DeclanRiedel/nixos-flake";
      dates = "weekly";
    };

  };
}
