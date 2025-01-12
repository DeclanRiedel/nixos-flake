{ pkgs, ... }: {

  plugins = {

    clangd-extensions.enable = true;

    lsp = {
      enable = true;

      servers = {
        nixd = {
          enable = true;
          autostart = true;
        };

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

        pyright.enable = true;

        bashls.enable = true;

        ols.enable = true;

        lua-ls.enable = true;

        cssls.enable = true;
        html.enable = true;
        htmx.enable = true;
        cmake.enable = true;
        zls.enable = true;

        sqls.enable = true;
        texlab.enable = true;

        hls.enable = true;

        gopls.enable = true;

        rust-analyzer = {
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
