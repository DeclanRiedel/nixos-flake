{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-codex.url = "github:NixOS/nixpkgs/master";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    worktrunk = {
      url = "github:max-sixty/worktrunk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zed-thread-tui = {
      url = "github:DeclanRiedel/zed-thread-tui";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, sops-nix, nixvim, nixpkgs-codex, nixpkgs-stable, worktrunk, ... }:
    let
      system = "x86_64-linux";
      pkgsUnfree = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          android_sdk.accept_license = true;
          # Pulled in transitively by an Electron app after the nixpkgs bump.
          permittedInsecurePackages = [ "electron-39.8.10" ];
        };
      };
      pkgsCodex = import nixpkgs-codex {
        inherit system;
        config.allowUnfree = true;
      };
      pkgsStable = import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
      homeManagerModule = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";
        home-manager.extraSpecialArgs = { inherit inputs; };
        home-manager.users.declan = {
          imports = [
            ./home-manager/home.nix
            nixvim.homeModules.nixvim
            worktrunk.homeModules.default
          ];
        };
      };
      mkHost = modules:
        nixpkgs.lib.nixosSystem {
          inherit system;
          pkgs = pkgsUnfree;
          modules = [
            {
              _module.args.pkgsCodex = pkgsCodex;
              _module.args.pkgsStable = pkgsStable;
            }
          ] ++ modules ++ [
            sops-nix.nixosModules.sops
            inputs.stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            homeManagerModule
          ];
        };
    in
    {
      formatter.${system} = pkgsUnfree.nixpkgs-fmt;

      apps.${system} = {
        # `nix run .#switch [host]` — build and activate the config for the
        # given host (defaults to the current hostname) via nh. Runs against
        # the working tree (`.`) so uncommitted edits are picked up.
        switch = {
          type = "app";
          program = toString (pkgsUnfree.writeShellScript "switch" ''
            set -euo pipefail
            host="''${1:-$(hostname)}"
            exec ${pkgsUnfree.nh}/bin/nh os switch --hostname "$host" .
          '');
        };

        # `nix run .#boot [host]` — same, but stage for next boot.
        boot = {
          type = "app";
          program = toString (pkgsUnfree.writeShellScript "boot" ''
            set -euo pipefail
            host="''${1:-$(hostname)}"
            exec ${pkgsUnfree.nh}/bin/nh os boot --hostname "$host" .
          '');
        };
      };

      checks.${system} = {
        format = pkgsUnfree.runCommand "nixos-format-check"
          {
            nativeBuildInputs = [ pkgsUnfree.nixpkgs-fmt ];
            src = self;
          } ''
          cp -r "$src" source
          chmod -R u+w source
          nixpkgs-fmt --check source
          touch "$out"
        '';

        deadnix = pkgsUnfree.runCommand "nixos-deadnix-check"
          {
            nativeBuildInputs = [ pkgsUnfree.deadnix ];
            src = self;
          } ''
          deadnix --fail "$src"
          touch "$out"
        '';

        statix = pkgsUnfree.runCommand "nixos-statix-check"
          {
            nativeBuildInputs = [ pkgsUnfree.statix ];
            src = self;
          } ''
          statix check --config "$src" "$src"
          touch "$out"
        '';
      };

      templates = {
        c-cpp = {
          path = ./templates/c-cpp;
          description = "C/C++ dev shell with GCC, Clang tools, CMake, Ninja, pkg-config, GDB, and Valgrind";
        };

        dotnet = {
          path = ./templates/dotnet;
          description = ".NET SDK dev shell for console, library, test, and F# workflows";
        };

        dotnet-android = {
          path = ./templates/dotnet-android;
          description = "NixOS .NET Android dev shell with project-local writable .NET workloads";
        };

        dotnet-maui = {
          path = ./templates/dotnet-maui;
          description = "NixOS .NET MAUI dev shell with project-local writable .NET workloads";
        };

        dotnet-web = {
          path = ./templates/dotnet-web;
          description = ".NET ASP.NET Core/API work with HTTPS dev-cert helpers and EF tooling path";
        };

        go = {
          path = ./templates/go;
          description = "Go dev shell with gopls, gotools, golangci-lint, and Delve";
        };

        node = {
          path = ./templates/node;
          description = "Node.js dev shell with pnpm, yarn, bun, TypeScript, and common JS tooling";
        };

        postgres = {
          path = ./templates/postgres;
          description = "PostgreSQL dev shell with project-local database state and helper scripts";
        };

        python = {
          path = ./templates/python;
          description = "Python dev shell with uv, ruff, pyright, pytest, and virtualenv defaults";
        };

        rust = {
          path = ./templates/rust;
          description = "Rust dev shell with cargo, rustfmt, clippy, rust-analyzer, bacon, and cargo-nextest";
        };

        latex = {
          path = ./templates/latex;
          description = "LaTeX dev shell with TeX Live, latexmk, chktex, and document build helpers";
        };
      };

      nixosConfigurations = {
        machine = mkHost [
          ./misc/config.nix
          ./modules/default.nix
          ./server/default.nix
        ];

        vostro = mkHost [
          ./hosts/vostro/default.nix
          ./modules/default.nix
        ];

        nixos-wsl = mkHost [
          inputs.nixos-wsl.nixosModules.default
          ./hosts/nixos-wsl/default.nix
        ];
      };
    };
}
