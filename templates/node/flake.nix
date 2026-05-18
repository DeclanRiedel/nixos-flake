{
  description = "Node.js development shell";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          bun
          eslint
          nodejs_22
          nodePackages.prettier
          nodePackages.tsx
          nodePackages.typescript
          pnpm
          yarn
        ];

        shellHook = ''
          export npm_config_cache="$PWD/.npm"
          export PNPM_HOME="$PWD/.pnpm-home"
          export PATH="$PNPM_HOME:$PATH"
          mkdir -p "$npm_config_cache" "$PNPM_HOME"
        '';
      };
    };
}
