{
  description = "Go development shell";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          delve
          go
          golangci-lint
          gopls
          gotools
        ];

        shellHook = ''
          export GOPATH="$PWD/.go"
          export GOMODCACHE="$GOPATH/pkg/mod"
          export GOCACHE="$PWD/.go/cache"
          export PATH="$GOPATH/bin:$PATH"
          mkdir -p "$GOMODCACHE" "$GOCACHE"
        '';
      };
    };
}
