{
  description = ".NET Android development shell";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          android_sdk.accept_license = true;
        };
      };

      androidBuild = pkgs.androidenv.composeAndroidPackages {
        platformVersions = [ "35" ];
        buildToolsVersions = [ "35.0.0" ];
      };

      dotnetChannel = "9.0";

      androidBootstrap = pkgs.writeShellScriptBin "android-bootstrap" ''
        set -euo pipefail

        channel="''${DOTNET_CHANNEL:-${dotnetChannel}}"
        workload="''${DOTNET_ANDROID_WORKLOAD:-android}"

        mkdir -p "$PWD/.dotnet" "$PWD/.dotnet-home" "$PWD/.nuget/packages"

        if [ ! -x "$PWD/.dotnet/dotnet" ]; then
          tmp="$(mktemp -d)"
          trap 'rm -rf "$tmp"' EXIT
          ${pkgs.curl}/bin/curl -fsSL https://dot.net/v1/dotnet-install.sh -o "$tmp/dotnet-install.sh"
          ${pkgs.bash}/bin/bash "$tmp/dotnet-install.sh" --channel "$channel" --install-dir "$PWD/.dotnet"
        fi

        "$PWD/.dotnet/dotnet" workload install "$workload"
        "$PWD/.dotnet/dotnet" workload list
      '';

      androidNew = pkgs.writeShellScriptBin "android-new" ''
        set -euo pipefail

        if [ "$#" -ne 1 ]; then
          echo "Usage: android-new <ProjectName>" >&2
          exit 2
        fi

        dotnet new android -n "$1" --no-restore
        dotnet restore "$1/$1.csproj"
      '';

      androidDoctor = pkgs.writeShellScriptBin "android-doctor" ''
        set -euo pipefail

        dotnet --info
        echo
        dotnet workload list
        echo
        sdkmanager --list_installed | sed -n '1,80p'
        echo
        java -version
      '';

      androidSmokeTest = pkgs.writeShellScriptBin "android-smoke-test" ''
        set -euo pipefail

        android-bootstrap
        workdir="$(mktemp -d -p "$PWD" android-smoke.XXXXXX)"
        trap 'rm -rf "$workdir"' EXIT
        dotnet new android -n SmokeAndroid -o "$workdir/SmokeAndroid" --no-restore
        dotnet build "$workdir/SmokeAndroid/SmokeAndroid.csproj" -f net9.0-android
      '';

      androidEnv = pkgs.buildFHSEnv {
        name = "dotnet-android-fhs";

        targetPkgs = pkgs: with pkgs; [
          androidBuild.androidsdk
          androidBootstrap
          androidDoctor
          androidNew
          androidSmokeTest
          bash
          curl
          git
          glibc
          gnused
          icu
          jdk17
          openssl
          unzip
          zlib
        ];

        runScript = "bash";

        profile = ''
          export DOTNET_ROOT="$PWD/.dotnet"
          export DOTNET_CLI_HOME="$PWD/.dotnet-home"
          export NUGET_PACKAGES="$PWD/.nuget/packages"
          export DOTNET_MULTILEVEL_LOOKUP=0
          export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
          export DOTNET_CLI_TELEMETRY_OPTOUT=1

          export ANDROID_HOME="${androidBuild.androidsdk}/libexec/android-sdk"
          export ANDROID_SDK_ROOT="$ANDROID_HOME"
          export JAVA_HOME="${pkgs.jdk17.home}"
          export PATH="$DOTNET_ROOT:$DOTNET_ROOT/tools:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

          if [ ! -x "$DOTNET_ROOT/dotnet" ]; then
            echo "Run 'android-bootstrap' once to install a writable project-local .NET SDK and Android workload."
          fi
        '';
      };
    in
    {
      packages.${system}.default = androidEnv;
      devShells.${system}.default = androidEnv.env;
    };
}
