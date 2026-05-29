{ pkgs, ... }:

let
  rosePineHyprcursor = pkgs.stdenvNoCC.mkDerivation {
    pname = "rose-pine-hyprcursor";
    version = "0.3.2-unstable-2026-05-29";

    src = pkgs.fetchFromGitHub {
      owner = "ndom91";
      repo = "rose-pine-hyprcursor";
      rev = "4b02963d0baf0bee18725cf7c5762b3b3c1392f1";
      hash = "sha256-ouuA8LVBXzrbYwPW2vNjh7fC9H2UBud/1tUiIM5vPvM=";
    };

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/share/icons/rose-pine-hyprcursor"
      cp -R . "$out/share/icons/rose-pine-hyprcursor/"
      runHook postInstall
    '';

    meta = {
      description = "Rose Pine themed BreezeX cursor theme for Hyprcursor";
      homepage = "https://github.com/ndom91/rose-pine-hyprcursor";
      license = pkgs.lib.licenses.mit;
    };
  };
in
{
  home.pointerCursor = {
    enable = true;
    package = rosePineHyprcursor;
    name = "rose-pine-hyprcursor";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
    hyprcursor.enable = true;
  };
}
