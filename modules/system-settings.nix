{ hostConfig, lib, pkgs, ... }: {

  #systemd bootloader 
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 2;
    systemd-boot.configurationLimit = lib.mkDefault 6;
  };

  networking = {
    networkmanager.enable = true;
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

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" hostConfig.user.name ];
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      ];
    };
  };

  systemd.services.nix-gc.preStart = ''
    ${pkgs.nix}/bin/nix-env --profile /nix/var/nix/profiles/system --delete-generations +6
  '';
}
