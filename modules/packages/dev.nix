{ pkgs, lib, pkgsCodex, ... }:

let
  opencodeLatest = import ../../pkgs/opencode-latest.nix { inherit lib pkgs; };
in
{
  environment.sessionVariables = {
    DOTNET_ROOT = "${pkgs.dotnet-sdk_9.unwrapped}/share/dotnet";
    JAVA_HOME = pkgs.jdk17.home;
  };

  environment.systemPackages = with pkgs; [
    gemini-cli
    pkgsCodex.codex
    opencodeLatest

    lazygit
    diff-so-fancy
    git-lfs
    gh
    jq
    ripgrep
    fd
    just

    vscode-fhs
    dotnet-sdk_9
    jdk17

    direnv
    nix-direnv
    nixd
    nil
    nixpkgs-fmt
    alejandra
    deadnix
    statix

    docker
  ];
}
