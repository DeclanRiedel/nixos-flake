{ ... }:

{
  programs.zathura = {
    enable = true;

    options = {
      adjust-open = "best-fit";
      recolor = true;
      recolor-keephue = true;
      selection-clipboard = "clipboard";
      pages-per-row = 1;
      scroll-page-aware = true;
      smooth-scroll = true;
      statusbar-home-tilde = true;
    };
  };
}
