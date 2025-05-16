{ lib, pkgs, ... }: {
  programs.tmux = {
    enable = true;
    shortcut = "a";
    keyMode = "vi";
    plugins = [ pkgs.tmuxPlugins.resurrect ];

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

      ### rice section
      set -g visual-activity off
      set -g visual-bell off
      set -g visual-silence off
      setw -g monitor-activity off
      set -g bell-action none
    '';

  };
}
