{
  imports = [
#    ./bufferline.nix

    ./options.nix
    ./plugins.nix
    ./keymaps.nix

    ./git.nix
    ./trouble.nix
    ./wilder.nix

    ./cmp.nix
    ./lsp.nix
    ./none-ls.nix
    ./treesitter.nix

  ];

  globals.mapleader = " ";

  colorschemes.tokyonight = {
    enable = true;
    settings = {
      transparent = true;
      style = "storm";
    };
  };

}
