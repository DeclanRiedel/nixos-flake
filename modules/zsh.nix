{
  programs = {
    zsh = {
      enable = true;
      zsh-autoenv.enable = true;
      syntaxHighlighting.enable = true;
      enableBashCompletion = true;
      ohMyZsh = {
        enable = true;
        plugins = [ "git" "history" ];
      };
      shellAliases = {
        ls = "ls -l";
        lst = "lsd --tree";
        update = "sudo nixos-rebuild switch --flake ~/.dotfiles/nixos-flake";
        c = "clear";
        n = "nvim";
        ndev = "nix develop .  && zsh";
        ## custom scripts 
        dshgen = "~/.dotfiles/nixos-flake/scripts/devshell-flake-gen.sh";
        jn = "~/.dotfiles/nixos-flake/scripts/daily-journal.sh";
        on = "~/.dotfiles/nixos-flake/scripts/obsidian-quicknote.sh";
      };
    };
  };
}
