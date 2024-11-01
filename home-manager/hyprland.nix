{
  home.file = { ".config/hypr/hyprland.conf".text = ''

# Monitor Configuration
monitor = eDP-1, highres, auto, 1
monitor = HDMI-A-1, 1920x1080@144, auto, 2, mirror, eDP-1

# XWayland Configuration
xwayland {
    force_zero_scaling = true
}

# Electron Apps Configuration
# Electron apps look pixelated with fractional scaling.
# Add to ???: ELECTRON_OZONE_PLATFORM_HINT=auto

# Autostart Applications
exec-once = waybar
exec-once = hypridle
exec-once = playerctld daemon
exec-once = swww-daemon & sleep 0.1 && swww img ~/Media/Pictures/1107
exec-once = sleep 0.3 && dropbox

# Environment Variables
env = HYPERCURSOR_THEME, MyCursor
env = HYPERCURSOR_SIZE, 22

# Input Configuration
input {
    kb_layout = us
    kb_variant =
    kb_model =
    kb_options =
    kb_rules =

    follow_mouse = 1

    touchpad {
        natural_scroll = no
    }

    sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
}

# General Configuration
general {
    gaps_in = 1.5
    gaps_out = 4
    border_size = 2
    col.active_border = rgba(7fffd4ee) rgba(ff7f50ee) 90deg
    col.inactive_border = rgba(595959aa)
    layout = dwindle
    allow_tearing = false
}

# Decoration Configuration
decoration {
    rounding = 8
    active_opacity = 1
    inactive_opacity = 1
    windowrulev2 = opacity 0.9 override, class:^(kitty)

    blur {
        enabled = true
        size = 6
        passes = 1
    }

    drop_shadow = yes
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
}

# Animation Configuration
animations {
    enabled = yes
    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = borderangle, 1, 8, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

# Dwindle Layout Configuration
dwindle {
    pseudotile = yes
    preserve_split = yes
}

# Gestures Configuration
gestures {
    workspace_swipe = off
}

# Miscellaneous Configuration
misc {
    force_default_wallpaper = 1
    disable_hyprland_logo = true
}

# Bindings
$mainMod = SUPER

# Application Launch Bindings
bind = $mainMod, Q, exec, kitty
bind = $mainMod, C, killactive
bind = $mainMod, L, exec, lorien
bind = $mainMod, D, exec, webcord
bind = $mainMod, E, exec, thunar
bind = $mainMod, W, exec, floorp
bind = $mainMod, P, exec, floorp --private-window
bind = $mainMod, Z, exec, zathura
bind = $mainMod, O, exec, code
bind = $mainMod, V, exec, pavucontrol
bind = $mainMod, B, exec, blueman-manager
bind = $mainMod, T, exec, seahorse
bind = $mainMod, M, exec, wlogout
bind = $mainMod, K, exec, hyprlock
bind = $mainMod, R, exec, fuzzel
bind = $mainMod, G, exec, grim -g "$(slurp -d)" ~/Media/Screenshots/$(date +'%s_grim.png)"
bind = $mainMod, H, exec, wl-screenrec ~/Recordings

# Floating and Tiling Bindings
bind = $mainMod, F, togglefloating
bind = $mainMod, I, pseudo
bind = $mainMod, J, togglesplit

# Focus Movement Bindings
bind = $mainMod, left, movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up, movefocus, u
bind = $mainMod, down, movefocus, d

# Playerctl Bindings
bind = ,XF86AudioPlay, exec, playerctl play-pause
bind = ,XF86AudioPause, exec, playerctl play-pause
bind = ,XF86AudioNext, exec, playerctl next
bind = ,XF86AudioPrev, exec, playerctl previous

# Resize Bindings
bind = $mainMod SHIFT, right, resizeactive, 5 0
bind = $mainMod SHIFT, left, resizeactive, -5 0
bind = $mainMod SHIFT, up, resizeactive, 0 -5
bind = $mainMod SHIFT, down, resizeactive, 0 5

# Workspace Bindings
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10

# Move Window to Workspace Bindings
bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10

# Special Workspace Binding
bind = $mainMod, S, togglespecialworkspace, magic
bind = $mainMod SHIFT, S, movetoworkspace, special:magic

# Workspace Scroll Bindings
bind = $mainMod, mouse_down, workspace, e+1
bind = $mainMod, mouse_up, workspace, e-1

# Move/Resize Window with Mouse Bindings
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow
'';
};
}
