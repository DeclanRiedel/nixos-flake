{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  system.stateVersion = "25.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.hostName = lib.mkForce "vostro";

  users.users.declan = {
    hashedPassword =
      "$6$EzXJslYBXtQdQTaM$bFTRUVkaBwvFoENgMsRH54UgvYCwiEJiskSL5UgNFMx/Q12GnRxDHJjZ0e9PbrpGELscaNVg.Ppp86zCvO9e20";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM6L3iyvr7PKLMkieNUsDVuywKC3xP12uobeMo5L8chv declan@declan-NucBox-K7-PLUS"
    ];
  };

  users.users.root = {
    initialPassword = "asdf";
    shell = pkgs.zsh;
  };
  services.openssh.settings.PasswordAuthentication = lib.mkForce true;
  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";
  services.openssh.extraConfig = lib.mkAfter ''
    PermitRootLogin yes
  '';
}
