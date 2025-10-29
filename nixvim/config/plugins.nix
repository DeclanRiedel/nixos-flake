# here all the plugins...................
{ pkgs, ... }: {
  plugins = {
    wtf.enable = true;

    #neorg.enable = true; #requires lazy or something? doesn't really matter

    vimtex = {
      enable = true;
      settings = {
        compiler_method = "latexmk";
        toc_config = {
          split_pos = "vert topleft";
          split_width = 40;
        };
        view_method = "zathura";
      };
    };
    #obsidian = {
    #  enable = true;
    #  settings = {
    #    ui = { enable = false; };
    #    dir = "~/Zettelkasten/";
    #    dir = "~/Zettelkasten/";
    #    #conceallevel = 2;
    #    new_notes_location = "~/Zettelkasten/00_Notes/Unsorted";
    #    completions = {
    #      min_chars = 2;
    #      nvim_cmp = true;
    #    };
    #    templates.subdir = "~/Zettelkasten/03_Misc/02_Templates/FullNote.md";
    #  };
    #};

    zen-mode.enable = true;

    #neocord.enable = true; #this is very weird no?

    #tmux-navigator.enable = true;
    dap.enable = true;

    friendly-snippets.enable = true;
    oil.enable = true;
    #lazygit.enable = true;
    vim-surround.enable = true;
    # dressing.enable = true;
    indent-blankline.enable = true;
    lualine.enable = true;
    # lightline.enable = true;
    toggleterm.enable = true; # <leader>~ for toggleterm
    which-key.enable = true;

    ## startup theme...
    alpha.enable = true;
    alpha.theme = "startify";
    #alpha.theme = "dashboard";

    # noice.enable = true;
    vim-css-color.enable = true;
    # notify.enable = true;

    #plugins.startup.enable = true;

    colorizer.enable = true;
    flash.enable = true; # like leap but better, much better.

    #sniprun = {
    #  enable = true;
    #  display = [ "Terminal" "VirtualText" ];
    #  liveModeToggle = "on";
    #};

    #commentary.enable = true; #comment.nvim easier to use?

    telescope.enable = true;
    telescope.extensions.file-browser.enable = true;
    comment.enable = true;
    neo-tree.enable = true;
    #twilight.enable = true; 
    nvim-autopairs = { enable = true; };

  };
}
