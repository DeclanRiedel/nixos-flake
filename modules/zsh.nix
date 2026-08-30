{ hostConfig, ... }:

let
  flakeDir = "${hostConfig.user.home}/.nixos";
in
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
        ls = "eza -l --no-filesize --icons";
        lst = "eza -T --icons";
        lsg = "eza -g --icons";
        lsd = "eza -g -D -T";
        lsgit = "eza --git-ignore -T --icons";
        cat = "bat";
        switch = "${flakeDir}/scripts/switch.sh";
        update = "${flakeDir}/scripts/switch.sh ${hostConfig.hostName}";
        c = "clear";
        n = "nvim";
        nmtui = "impala";
        vim = "nvim";
        ndev = "nix develop . -c $SHELL";
        todo = "nvim ~/Zettelkasten/03_Misc/Todo.md";
        ## custom scripts 
        dshgen = "../scripts/devshell-flake-gen.sh";
        jn = "../scripts/obsidian-daily.sh";
        on = "../scripts/obsidian-note.sh";
      };
    };
  };
}
