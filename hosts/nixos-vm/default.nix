{ lib, pkgs, ... }:

{
  imports = [
    ../../modules/zsh.nix
    ../../modules/user-settings.nix
    ../../modules/fonts.nix
    ../../modules/tmux.nix
    ../../modules/packages/core.nix
    ../../modules/packages/dev.nix
    ../../modules/packages/media.nix
    ../../modules/packages/apps.nix
  ];

  system.stateVersion = "25.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.hostName = lib.mkForce "nixos-vm";

  wsl = {
    enable = true;
    defaultUser = "declan";
    useWindowsDriver = true;
    startMenuLaunchers = true;
    wslConf = {
      boot.systemd = true;
      interop = {
        enabled = true;
        appendWindowsPath = true;
      };
      automount = {
        enabled = true;
        root = "/mnt";
        options = "metadata,uid=1000,gid=100";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    firefox
    gnome-text-editor
    mesa-demos
    xeyes
  ];

  services.openssh.enable = true;
  programs.ssh.startAgent = true;

  users.users.declan.linger = true;
  users.users.root.shell = pkgs.zsh;
}
