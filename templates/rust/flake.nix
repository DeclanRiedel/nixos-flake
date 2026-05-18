{
  description = "Rust development shell";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          bacon
          cargo
          cargo-nextest
          clippy
          openssl
          pkg-config
          rust-analyzer
          rustc
          rustfmt
        ];

        shellHook = ''
          export RUST_BACKTRACE=1
        '';
      };
    };
}
