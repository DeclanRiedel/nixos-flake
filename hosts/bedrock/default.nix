{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./server
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 22 ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  users.users.root = {
    shell = pkgs.bashInteractive;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM6L3iyvr7PKLMkieNUsDVuywKC3xP12uobeMo5L8chv declan@declan-NucBox-K7-PLUS"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB36tS6T6hOQ+PlarOlfrF2uwbsSMD9EOBr5KpUo5Bay declan.riedel@protonmail.com"
    ];
  };

  environment.systemPackages = with pkgs; [
    curl
    git
    vim
    wget
  ];

  system.stateVersion = "25.11";
}
