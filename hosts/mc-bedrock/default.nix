{ pkgs, sshKeys, ... }:

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
    openssh.authorizedKeys.keys = sshKeys.admins;
  };

  environment.systemPackages = with pkgs; [
    curl
    git
    vim
    wget
  ];

  system.stateVersion = "25.11";
}
