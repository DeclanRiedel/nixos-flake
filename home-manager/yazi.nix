{ lib, pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    shellWrapperName = "y";

    extraPackages = with pkgs; [
      fd
      ffmpegthumbnailer
      jq
      ouch
      p7zip
      poppler-utils
      ripgrep
      unzip
    ];

    settings = {
      mgr = {
        ratio = [ 1 3 4 ];
        sort_by = "natural";
        sort_dir_first = true;
        linemode = "size";
        show_hidden = false;
        show_symlink = true;
      };

      preview = {
        tab_size = 2;
        max_width = 1200;
        max_height = 1800;
        cache_dir = "";
      };
    };

    keymap = {
      mgr.prepend_keymap = [
        {
          on = [ "." ];
          run = "hidden toggle";
          desc = "Toggle hidden files";
        }
        {
          on = [ "g" "w" ];
          run = "cd ~/work";
          desc = "Go to work directory";
        }
        {
          on = [ "g" "n" ];
          run = "cd ~/.nixos";
          desc = "Go to NixOS flake";
        }
      ];
    };

    theme = lib.mkForce {
      mgr = {
        cwd = { fg = "#33ffff"; };
        hovered = {
          fg = "#000000";
          bg = "#ffaa33";
          bold = true;
        };
        preview_hovered = {
          fg = "#000000";
          bg = "#33ffff";
        };
        marker_copied = { fg = "#99ff33"; };
        marker_cut = { fg = "#ff6666"; };
        marker_marked = { fg = "#ffaa33"; };
        count_copied = {
          fg = "#000000";
          bg = "#99ff33";
        };
        count_cut = {
          fg = "#000000";
          bg = "#ff6666";
        };
        count_selected = {
          fg = "#000000";
          bg = "#33ffff";
        };
        border_symbol = "│";
        border_style = { fg = "#333333"; };
      };

      status = {
        separator_open = "";
        separator_close = "";
        mode_normal = {
          fg = "#000000";
          bg = "#33ffff";
          bold = true;
        };
        mode_select = {
          fg = "#000000";
          bg = "#ffaa33";
          bold = true;
        };
        mode_unset = {
          fg = "#000000";
          bg = "#ff6666";
          bold = true;
        };
      };

      filetype.rules = [
        {
          mime = "image/*";
          fg = "#33ffff";
        }
        {
          mime = "video/*";
          fg = "#ffaa33";
        }
        {
          mime = "audio/*";
          fg = "#cc66ff";
        }
        {
          mime = "application/{zip,rar,7z*,tar,gzip,xz}";
          fg = "#ff6666";
        }
        {
          name = "*";
          fg = "#dddddd";
        }
        {
          name = "*/";
          fg = "#33aaff";
        }
      ];
    };
  };
}
