{ lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  system.stateVersion = "25.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.hostName = lib.mkForce "vostro";

  users.users.declan = {
    hashedPasswordFile = "/home/declan/.nixos/secrets/passwords/declan.hash";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM6L3iyvr7PKLMkieNUsDVuywKC3xP12uobeMo5L8chv declan@declan-NucBox-K7-PLUS"
    ];
  };

  users.users.root = {
    hashedPasswordFile = "/home/declan/.nixos/secrets/passwords/root.hash";
    shell = pkgs.zsh;
  };
  services.openssh.settings.PasswordAuthentication = lib.mkForce true;
  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";
  services.openssh.extraConfig = lib.mkAfter ''
    PermitRootLogin yes
  '';
  boot.kernelModules = [ "uinput" ];

  services.udev.extraRules = ''
    KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
  '';

  services.sunshine = {
    enable = true;
    openFirewall = true;
    capSysAdmin = true;
    settings = {
      capture = "kms";
    };
  };
}
