{ lib, pkgs, ... }:

let
  profileDir = ".floorp/g7it090d.default-default";
in
{
  home.activation.floorpUserJs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    PROFILE="$HOME/${profileDir}"
    if [ -d "$PROFILE" ]; then
      $DRY_RUN_CMD rm -f "$PROFILE/user.js"
      $DRY_RUN_CMD ${pkgs.coreutils}/bin/install -m 0644 ${../config/floorp/user.js} "$PROFILE/user.js"
    fi
  '';
}
