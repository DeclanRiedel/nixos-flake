{ config, lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  services.thermald.enable = true;
  powerManagement.powertop.enable = true;

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/14ec8032-ae71-48cf-971e-496b1a9cf81a";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/47F0-672F";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  swapDevices = [ ];

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

  networking.useDHCP = lib.mkDefault true;
  networking.firewall.allowedTCPPorts = [ 22 4321 5432 5900 3000 8080 ];
  networking.firewall.allowedTCPPortRanges = [
    {
      from = 5000;
      to = 7999;
    }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
