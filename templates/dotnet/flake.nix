{
  description = ".NET development shell";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          dotnet-sdk_9
          git
          icu
          openssl
        ];

        shellHook = ''
          export DOTNET_ROOT="${pkgs.dotnet-sdk_9}"
          export DOTNET_CLI_HOME="$PWD/.dotnet-home"
          export NUGET_PACKAGES="$PWD/.nuget/packages"
          export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
          export DOTNET_CLI_TELEMETRY_OPTOUT=1
          mkdir -p "$DOTNET_CLI_HOME" "$NUGET_PACKAGES"
        '';
      };
    };
}
