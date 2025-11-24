{ lib, pkgs, ... }: {
  programs.tmux = {
    enable = true;
    shortcut = "a";
    keyMode = "vi";
    plugins = [ pkgs.tmuxPlugins.resurrect pkgs.tmuxPlugins.continuum ];

    extraConfig = ''
      #reference https://hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/

      # split panes using | and -
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %

      # switch panes using Alt-arrow without prefix
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # don't rename windows automatically
      set-option -g allow-rename off

      # Enable mouse support
      set -g mouse on

      # Shorter delay when switching panes
      set -sg escape-time 10

      # --- Plugins ---
      # Automatically restore sessions on tmux start
      set -g @continuum-restore 'on'

      ### rice section
      set -g visual-activity off
      set -g visual-bell off
      set -g visual-silence off
      setw -g monitor-activity off
      set -g bell-action none
    '';

  };
}

#
# ==============================================================================
# TMUX CHEATSHEET & PERSISTENCE GUIDE
# ==============================================================================
#
# Your tmux configuration is set up to automatically save your sessions
# and restore them when you reboot or restart tmux. This is handled by
# the 'tmux-continuum' plugin, which works with 'tmux-resurrect'.
#
# ------------------------------------------------------------------------------
# KEYBINDINGS (Prefix: Ctrl-b)
# ------------------------------------------------------------------------------
#
# The "prefix" is the first key combination you press before a command.
# Your Prefix: Ctrl-b (default)
#
# Panes (Splits):
#   - `|`                : Split pane vertically.
#   - `-`                : Split pane horizontally.
#   - Alt + Arrow Keys   : Navigate between panes without the prefix.
#   - `prefix` + x       : Kill the current pane.
#
# Windows (Tabs):
#   - `prefix` + c       : Create a new window.
#   - `prefix` + n       : Go to the next window.
#   - `prefix` + p       : Go to the previous window.
#   - `prefix` + [0-9]   : Go to window number [0-9].
#   - `prefix` + ,       : Rename the current window.
#
# Sessions:
#   - `tmux ls`          : (In your shell) List all running tmux sessions.
#   - `tmux a -t [name]` : (In your shell) Attach to a named session.
#   - `prefix` + d       : Detach from the current session (it keeps running).
#   - `prefix` + s       : Interactively list and switch between sessions.
#
# ------------------------------------------------------------------------------
# SESSION PERSISTENCE (Automatic)
# ------------------------------------------------------------------------------
#
# This setup uses `tmux-resurrect` and `tmux-continuum` for persistence.
#
# - Automatic Saving: `tmux-continuum` saves your sessions every 15 minutes by default.
# - Automatic Restoring: When you start tmux for the first time after a
#   reboot, `tmux-continuum` automatically restores your last saved session.
#
# You don't need to do anything manually. Just create your sessions, windows,
# and panes, and they will be there the next time you start tmux.
#
# To force a save (e.g., before a reboot):
#   - `prefix` + Ctrl-s
#
# To force a restore (if it doesn't happen automatically):
#   - `prefix` + Ctrl-r
#
