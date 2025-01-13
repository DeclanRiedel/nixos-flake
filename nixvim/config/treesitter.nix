{
  plugins = {
    treesitter = {
      enable = true;
      nixGrammars = true;
      settings.indent.enable = true;
    };
    treesitter-context.enable = true;
    rainbow-delimiters.enable = true;
  };

}
