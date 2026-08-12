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
      defaultSystem = "x86_64-linux";
      defaultUser = { name = "declan"; home = "/home/declan"; };
      hosts = {
        vostro = {
          modules = [
            ./hosts/vostro/default.nix
            ./modules/default.nix
            ./modules/ai-auto-update.nix
            ./hosts/vostro/memory.nix
          ];
        };
        nixos-wsl = {
          modules = [
            inputs.nixos-wsl.nixosModules.default
            ./hosts/nixos-wsl/default.nix
          ];
        };
        mc-bedrock = {
          homeManager = false;
          modules = [
            ./hosts/mc-bedrock/default.nix
          ];
        };
      };
      mkPkgs = system: import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          android_sdk.accept_license = true;
        };
      };
      mkHomeManagerModule = hostConfig: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";
        home-manager.extraSpecialArgs = { inherit inputs hostConfig; };
        home-manager.users.${hostConfig.user.name} = {
          imports = [
            ./home-manager/home.nix
            nixvim.homeModules.nixvim
            worktrunk.homeModules.default
          ];
        };
      };
      mkHost = hostName: host:
        let
          system = host.system or defaultSystem;
          pkgsUnfree = mkPkgs system;
          pkgsCodex = import nixpkgs-codex {
            inherit system;
            config.allowUnfree = true;
          };
          pkgsStable = import nixpkgs-stable {
            inherit system;
            config.allowUnfree = true;
          };
          hostConfig = host // {
            inherit hostName system;
            user = host.user or defaultUser;
          };
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          pkgs = pkgsUnfree;
          specialArgs = { inherit inputs hostConfig pkgsCodex pkgsStable; };
          modules = host.modules ++ [
            {
              networking.hostName = nixpkgs.lib.mkDefault hostName;
            }
            sops-nix.nixosModules.sops
          ] ++ nixpkgs.lib.optionals (host.homeManager or true) [
            inputs.stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            (mkHomeManagerModule hostConfig)
          ];
        };
      pkgsUnfree = mkPkgs defaultSystem;
    in
    {
      formatter.${defaultSystem} = pkgsUnfree.nixpkgs-fmt;

      apps.${defaultSystem} = {
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

      checks.${defaultSystem} = {
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

      nixosConfigurations = nixpkgs.lib.mapAttrs mkHost hosts;
    };
}
