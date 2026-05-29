{ lib, ... }:

let
  profileDir = ".floorp/g7it090d.default-default";
in
{
  home.activation.floorpUserJs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    PROFILE="$HOME/${profileDir}"
    if [ -d "$PROFILE" ]; then
      $DRY_RUN_CMD cp $VERBOSE_ARG ${../config/floorp/user.js} "$PROFILE/user.js"
    fi
  '';
}
