{
  home.file = {
    ".config/fuzzel/fuzzel.ini".text = ''
      # See also man 5 fuzzel.ini

      [main]
      prompt = "🚀  "
      width = 30 
      vertical-pad = 13
      line-height = 18
      # Add extra "exec" fields for Nautilus named "文件" in Chinese so can no be
      # fuzzy searched.
      fields = filename,name,generic,exec

      [border]
      width = 0

      [colors]
      background = 4c566add
      selection = 2e3440ff
      text = d8dee9ff
      selection-text = eceff4ff
      match = 81a1c1ff
      selection-match = 88c0d0ff
    '';
  };
}
