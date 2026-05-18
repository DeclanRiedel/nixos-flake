{
  description = "C/C++ development shell";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          clang-tools
          cmake
          gdb
          gcc
          gnumake
          ninja
          pkg-config
          valgrind
        ];

        shellHook = ''
          export CMAKE_EXPORT_COMPILE_COMMANDS=1
        '';
      };
    };
}
