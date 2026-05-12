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
    flake-parts.url = "github:hercules-ci/flake-parts";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-codex.url = "github:NixOS/nixpkgs/c6e5ca3c836a5f4dd9af9f2c1fc1c38f0fac988a";
    worktrunk = {
      url = "github:max-sixty/worktrunk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nixvim, nixpkgs-codex, worktrunk, ... }:
    let
      system = "x86_64-linux";
      pkgsCodex = import nixpkgs-codex {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations = {
        machine = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            { _module.args.pkgsCodex = pkgsCodex; }
            {
              nixpkgs.config = {
                allowUnfree = true;
                android_sdk.accept_license = true;
              };
            }
            ./misc/config.nix
            ./modules/default.nix
            ./server/default.nix
            inputs.stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.declan = {
                imports = [
                  ./home-manager/home.nix
                  nixvim.homeModules.nixvim
                  worktrunk.homeModules.default
                ];
              };
            }
          ];
        };

        vostro = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            { _module.args.pkgsCodex = pkgsCodex; }
            {
              nixpkgs.config = {
                allowUnfree = true;
                android_sdk.accept_license = true;
              };
            }
            ./hosts/vostro/default.nix
            ./modules/default.nix
            inputs.stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.declan = {
                imports = [
                  ./home-manager/home.nix
                  nixvim.homeModules.nixvim
                  worktrunk.homeModules.default
                ];
              };
            }
          ];
        };
      };
    };
}
