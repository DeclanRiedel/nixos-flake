{ inputs, lib, pkgs, ... }:

let
  zedThreadRunner = inputs.zed-thread-tui.packages.${pkgs.stdenv.hostPlatform.system}.default;
  slotCount = 9;
  slots = lib.range 1 slotCount;
  action = "$HOME/.local/bin/zed-thread-leader-action";
  reset = "${pkgs.hyprland}/bin/hyprctl dispatch submap reset";
  runCombo = slot: combo: "${action} ${toString slot}${combo}; ${reset}";
  slotEntryBindings = lib.concatStringsSep "\n" (
    map (slot: "bind = , ${toString slot}, submap, zedthread-${toString slot}") slots
  );
  slotActionSubmaps = lib.concatStringsSep "\n\n" (
    map
      (slot:
        let
          id = toString slot;
        in
        ''
          submap = zedthread-${id}
          bind = , escape, submap, reset
          bind = , Control_R, submap, reset
          bind = , f, exec, ${runCombo slot "f"}
          bind = SHIFT, f, exec, ${runCombo slot "F"}
          bind = , r, exec, ${runCombo slot "r"}
          bind = , x, exec, ${runCombo slot "x"}
          bind = , a, exec, ${runCombo slot "a"}
          bind = , h, exec, ${runCombo slot "h"}
          bind = SHIFT, 1, exec, ${runCombo slot "!"}
          bind = SHIFT, 2, exec, ${runCombo slot "@"}
          bind = , s, submap, zedthread-${id}-s
          bind = SHIFT, r, submap, zedthread-${id}-R

          submap = zedthread-${id}-s
          bind = , escape, submap, reset
          bind = , Control_R, submap, reset
          bind = , 1, exec, ${runCombo slot "s1"}
          bind = , 2, exec, ${runCombo slot "s2"}

          submap = zedthread-${id}-R
          bind = , escape, submap, reset
          bind = , Control_R, submap, reset
          bind = , 1, exec, ${runCombo slot "R1"}
          bind = , 2, exec, ${runCombo slot "R2"}
        '')
      slots
  );
in
{
  home.file.".config/hypr/hyprland.conf" = {
    source = ../config/hyprland.conf;
    force = true;
  };

  home.file.".local/bin/zed-thread-leader-action" = {
    executable = true;
    text = ''
      #!${pkgs.runtimeShell}
      exec ${zedThreadRunner}/bin/zed-thread-runner --leader-combo "$1"
    '';
  };

  home.file.".config/hypr/zed-thread-leader.conf" = {
    text = ''
      # zed-thread-runner global leader bindings.
      # Press Right Ctrl, then a slot number, then an action.
      bind = , Control_R, submap, zedthread

      submap = zedthread
      bind = , escape, submap, reset
      bind = , Control_R, submap, reset
      ${slotEntryBindings}

      ${slotActionSubmaps}

      submap = reset
    '';
  };
}
