{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    nixvim.url = "github:nix-community/nixvim";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ nixpkgs, home-manager, nixvim, flake-parts, ... }:
    let
      system = "x86_64-linux";
      nixvimLib = nixvim.lib.${system};
      nixvim' = nixvim.legacyPackages.${system};
      nixvimModule = {
        pkgs = nixpkgs.legacyPackages.${system};
        module = import ./nixvim/config/default.nix;
      };
      nvim = nixvim'.makeNixvimWithModule nixvimModule;
    in {
      nixosConfigurations = {
        machine = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./misc/config.nix
            ./modules/default.nix
            ./server/default.nix
            inputs.stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.declan = import ./home-manager/home.nix;
            }
          ];
        };
      };

      packages.${system} = { default = nvim; };

      checks.${system} = {
        default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
      };
    };
}
