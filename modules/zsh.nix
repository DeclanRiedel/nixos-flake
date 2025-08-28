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
        todo = "nvim ~/obsidian/03_Misc/Todo.md";
        ## custom scripts 
         dshgen = "../scripts/devshell-flake-gen.sh";
         jn = "../scripts/obsidian-daily.sh";
         on = "../scripts/obsidian-note.sh";
      };
    };
  };
}
