{
  programs = {
    zsh = {
      enable = true;
      zsh-autoenv.enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      enableBashCompletion = true;

      #history = {
      #  expireDuplicatesFirst = true;
      #  extended = true;
      #};

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
        ndev = "nix develop . -c $SHELL";
        todo = "nvim ~/Dropbox/zettelkasten/8\\ -\\ Lists/1\\ -\\ Todo.md";
        ## custom scripts 
        dshgen = "~/.dotfiles/nixos-flake/scripts/devshell-flake-gen.sh";
        jn = "~/.dotfiles/nixos-flake/scripts/obsidian-daily.sh";
        on = "~/.dotfiles/nixos-flake/scripts/obsidian-note.sh";
      };
    };
  };
}
