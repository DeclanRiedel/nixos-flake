{ pkgs, ... }: {

  plugins = {

    clangd-extensions.enable = true;

    web-devicons.enable = true;

    lsp = {
      enable = true;

      servers = {
        nixd = {
          enable = true;
          autostart = true;
        };

        asm_lsp.enable = true;
        astro.enable = true;
        arduino_language_server.enable = true;
        eslint.enable = true;
        nextls.enable = true;

        jsonls.enable = true;

        clangd = {
          enable = true;
          autostart = true;
        };

        #csharp-ls = { enable = true; };

        omnisharp = {
          enable = true;
          settings.enableRoslynAnalyzers = true;
        };

        ruff.enable = true;

        #pyright.enable = true;

        bashls.enable = true;

        ols.enable = true;

        lua_ls.enable = true;

        cssls.enable = true;
        html.enable = true;
        
        htmx.enable = false;
        cmake.enable = false;
        zls.enable = false;

        sqls.enable = true;
        texlab.enable = true;

        hls = {
          enable = false;
          installGhc = false;
        };

        gopls.enable = true;

        rust_analyzer = {
          enable = true;
          installCargo = true;
          installRustc = true;
        };
      };

      keymaps.lspBuf = {
        "gd" = "definition";
        "gD" = "references";
        "gt" = "type_definition";
        "gi" = "implementation";
        "K" = "hover";
      };

    };
  };

}
