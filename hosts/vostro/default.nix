{ hostConfig, inputs, pkgs, ... }:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
    inputs.stylix.nixosModules.stylix
    ./hardware-configuration.nix
    ./networking.nix
    ./power.nix
    ./remote.nix
    ./memory.nix
    ../../modules/default.nix
    ../../modules/ai-auto-update.nix
    ../../modules/secrets.nix
  ];

  system.stateVersion = "25.11";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  users.users.${hostConfig.user.name} = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM6L3iyvr7PKLMkieNUsDVuywKC3xP12uobeMo5L8chv declan@declan-NucBox-K7-PLUS"
    ];
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "input"
      "render"
      "seat"
      "docker"
      "dialout"
    ];
  };

  users.users.root = {
    shell = pkgs.zsh;
  };
}
