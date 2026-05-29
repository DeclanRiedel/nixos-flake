{ ... }:

{
  home.file.".config/zed/settings.json" = {
    source = ../config/zed/settings.json;
    force = true;
  };
  home.file.".config/zed/keymap.json" = {
    source = ../config/zed/keymap.json;
    force = true;
  };
  home.file.".config/zed/tasks.json" = {
    source = ../config/zed/tasks.json;
    force = true;
  };
}
