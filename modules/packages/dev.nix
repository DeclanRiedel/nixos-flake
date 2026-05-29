{ pkgs, lib, pkgsCodex, ... }:

let
  opencodeLatest = import ../../pkgs/opencode-latest.nix { inherit lib pkgs; };
  prince = pkgs.callPackage ../../pkgs/prince.nix { };
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
    prince

    lazygit
    diff-so-fancy
    git-lfs
    gh
    jq
    ripgrep
    fd
    just

    vscode-fhs
    zed-editor
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
