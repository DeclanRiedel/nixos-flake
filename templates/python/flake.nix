{
  description = "Python development shell";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      python = pkgs.python312;
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          python
          pkgs.ipython
          pkgs.pyright
          pkgs.ruff
          pkgs.uv
          pkgs.python312Packages.pytest
        ];

        shellHook = ''
          export VIRTUAL_ENV="$PWD/.venv"
          export UV_PROJECT_ENVIRONMENT="$VIRTUAL_ENV"
          export PATH="$VIRTUAL_ENV/bin:$PATH"
        '';
      };
    };
}
