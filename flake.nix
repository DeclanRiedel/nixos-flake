{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-codex.url = "github:NixOS/nixpkgs/c6e5ca3c836a5f4dd9af9f2c1fc1c38f0fac988a";
    worktrunk = {
      url = "github:max-sixty/worktrunk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zed-thread-tui = {
      url = "github:DeclanRiedel/zed-thread-tui";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nixvim, nixpkgs-codex, worktrunk, ... }:
    let
      system = "x86_64-linux";
      pkgsUnfree = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          android_sdk.accept_license = true;
        };
      };
      pkgsCodex = import nixpkgs-codex {
        inherit system;
        config.allowUnfree = true;
      };
      homeManagerModule = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
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
            { _module.args.pkgsCodex = pkgsCodex; }
          ] ++ modules ++ [
            inputs.stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            homeManagerModule
          ];
        };
    in
    {
      formatter.${system} = pkgsUnfree.nixpkgs-fmt;

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
        dotnet-maui = {
          path = ./templates/dotnet-maui;
          description = "NixOS .NET MAUI dev shell with project-local writable .NET workloads";
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
      };
    };
}
