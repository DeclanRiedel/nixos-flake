{
  description = "LaTeX development shell";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      tex = pkgs.texlive.combine {
        inherit (pkgs.texlive)
          collection-basic
          collection-bibtexextra
          collection-binextra
          collection-fontsrecommended
          collection-latex
          collection-latexextra
          collection-latexrecommended
          collection-mathscience
          latexmk
          ;
      };

      latexBuild = pkgs.writeShellScriptBin "latex-build" ''
        set -euo pipefail

        file="''${1:-main.tex}"
        mkdir -p build
        latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=build "$file"
        cp "build/$(basename "''${file%.tex}").pdf" .
      '';

      latexWatch = pkgs.writeShellScriptBin "latex-watch" ''
        set -euo pipefail

        file="''${1:-main.tex}"
        mkdir -p build
        latexmk -pdf -pvc -interaction=nonstopmode -halt-on-error -outdir=build "$file"
      '';

      latexClean = pkgs.writeShellScriptBin "latex-clean" ''
        set -euo pipefail

        latexmk -C -outdir=build || true
        rm -rf build
      '';
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          tex
          pkgs.texlivePackages.chktex
          pkgs.zathura
          latexBuild
          latexWatch
          latexClean
        ];
      };
    };
}
