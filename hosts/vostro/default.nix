{ hostConfig, inputs, pkgs, sshKeys, ... }:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
    inputs.stylix.nixosModules.stylix
    ./hardware-configuration.nix
    ./networking.nix
    ./power.nix
    ./remote.nix
    ./memory.nix
    ./system.nix
    ./secrets.nix
    ./development.nix
    ../../modules/zsh.nix
    ../../modules/user-settings.nix
    ../../modules/fhs.nix
    ../../modules/packages
    ../../modules/desktop.nix
    ../../modules/fonts.nix
    ../../modules/sddm.nix
    ../../modules/stylix.nix
    ../../modules/tmux.nix
    ../../modules/ai-auto-update.nix
  ];

  system.stateVersion = "25.11";

  users.users.${hostConfig.user.name} = {
    openssh.authorizedKeys.keys = [ sshKeys.nucBox ];
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
