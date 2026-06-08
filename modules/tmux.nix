{ pkgs, ... }:

let
  tmuxStart = pkgs.writeShellScript "tmux-start" ''
    set -euo pipefail

    mkdir -p "$HOME/.local/state/tmux/resurrect"

    if ! ${pkgs.tmux}/bin/tmux has-session 2>/dev/null; then
      ${pkgs.tmux}/bin/tmux new-session -d -s main
    fi
  '';

  tmuxSave = pkgs.writeShellScript "tmux-save" ''
    set -euo pipefail

    if ${pkgs.tmux}/bin/tmux has-session 2>/dev/null; then
      ${pkgs.tmux}/bin/tmux run-shell "${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/scripts/save.sh quiet"
    fi
  '';
in
{
  programs.tmux = {
    enable = true;
    shortcut = "b";
    keyMode = "vi";
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      vim-tmux-navigator
      resurrect
      continuum
    ];

    extraConfig = ''
        set -g base-index 1
        setw -g pane-base-index 1
        set-option -g renumber-windows on
        set-option -g allow-rename off

        bind | split-window -h -c "#{pane_current_path}"
        bind -n C-o split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"
        unbind '"'
        unbind %

        bind -n M-Left select-pane -L
        bind -n M-Right select-pane -R
        bind -n M-Up select-pane -U
        bind -n M-Down select-pane -D

        set -g mouse on
        set -sg escape-time 10

        set -g status on
        set -g @continuum-save-interval '5'
        set -g @continuum-restore 'on'
        set -g @resurrect-dir '$HOME/.local/state/tmux/resurrect'
        set -g @resurrect-capture-pane-contents 'on'
        set -g @resurrect-strategy-vim 'session'
        set -g @resurrect-strategy-nvim 'session'
        set -g @resurrect-processes 'ssh mosh-client lazygit yazi ranger btop htop psql sqlite3'

        set -g visual-activity off
        set -g visual-bell off
        set -g visual-silence off
        setw -g monitor-activity off
        set -g bell-action none

        set -g status-interval 5
        set -g status-position bottom
        set -g status-style 'bg=#050505,fg=#bbbbbb'
        set -g status-left-length 48
        set -g status-right-length 120
        set -g status-left '#[bg=#33ffff,fg=#000000,bold] #S #[bg=#151515,fg=#33ffff]#[bg=#151515,fg=#dddddd] #{pane_current_command} '
        set -g status-right '#[fg=#777777]#{pane_current_path} #[fg=#ff6666]#(git -C "#{pane_current_path}" branch --show-current 2>/dev/null) #[fg=#33aaff]%H:%M '

        setw -g window-status-separator ""
        setw -g window-status-format '#[bg=#050505,fg=#777777] #I:#W '
        setw -g window-status-current-format '#[bg=#ffaa33,fg=#000000,bold] #I:#W '
        setw -g window-status-activity-style 'bg=#050505,fg=#ff6666,bold'

      set -g pane-border-style 'fg=#333333'
      set -g pane-active-border-style 'fg=#33ffff'
      set -g message-style 'bg=#151515,fg=#33ffff'
      set -g mode-style 'bg=#33ffff,fg=#000000,bold'
    '';

  };

  systemd.user.services.tmux = {
    description = "Start tmux server for automatic session restore";
    wantedBy = [ "default.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = tmuxStart;
      ExecStop = tmuxSave;
    };
  };
}
