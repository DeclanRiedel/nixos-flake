{
  description = "NixOS .NET MAUI development shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

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

      androidEmulator = pkgs.androidenv.composeAndroidPackages {
        platformVersions = [ "35" ];
        buildToolsVersions = [ "35.0.0" ];
        includeEmulator = true;
        includeSystemImages = true;
        abiVersions = [ "x86_64" ];
        systemImageTypes = [ "google_apis_playstore" ];
      };

      dotnetMajor = "9.0";
      dotnetChannel = "9.0";

      mauiBootstrap = pkgs.writeShellScriptBin "maui-bootstrap" ''
        set -euo pipefail

        channel="''${DOTNET_CHANNEL:-${dotnetChannel}}"
        workload="''${MAUI_WORKLOAD:-maui-android}"

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

      mauiDoctor = pkgs.writeShellScriptBin "maui-doctor" ''
        set -euo pipefail

        echo "DOTNET_ROOT=$DOTNET_ROOT"
        dotnet --info
        echo
        dotnet workload list
        echo
        echo "ANDROID_HOME=$ANDROID_HOME"
        sdkmanager --list_installed | sed -n '1,80p'
        echo
        java -version
      '';

      mauiNewAndroid = pkgs.writeShellScriptBin "maui-new-android" ''
        set -euo pipefail

        if [ "$#" -ne 1 ]; then
          echo "Usage: maui-new-android <ProjectName>" >&2
          exit 2
        fi

        name="$1"

        if ! command -v dotnet >/dev/null 2>&1; then
          echo "dotnet not found. Run maui-bootstrap first." >&2
          exit 1
        fi

        dotnet new maui -n "$name" --no-restore
        project="$name/$name.csproj"
        sed -i -E 's#<TargetFrameworks>[^<]+</TargetFrameworks>#<TargetFrameworks>net9.0-android</TargetFrameworks>#' "$project"
        dotnet restore "$project"

        echo
        echo "Created Android-only MAUI project: $project"
        echo "Build with: dotnet build $project -f net9.0-android"
      '';

      mauiSmokeTest = pkgs.writeShellScriptBin "maui-smoke-test" ''
        set -euo pipefail

        maui-bootstrap
        workdir="$(mktemp -d -p "$PWD" maui-smoke.XXXXXX)"
        trap 'rm -rf "$workdir"' EXIT

        dotnet new maui -n SmokeMaui -o "$workdir/SmokeMaui" --no-restore
        project="$workdir/SmokeMaui/SmokeMaui.csproj"
        sed -i -E 's#<TargetFrameworks>[^<]+</TargetFrameworks>#<TargetFrameworks>net9.0-android</TargetFrameworks>#' "$project"
        dotnet build "$project" -f net9.0-android
      '';

      mkMauiEnv = name: android: pkgs.buildFHSEnv {
        inherit name;

        targetPkgs = pkgs: with pkgs; [
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
          android.androidsdk
          mauiBootstrap
          mauiDoctor
          mauiNewAndroid
          mauiSmokeTest
        ];

        runScript = "bash";

        profile = ''
          export DOTNET_ROOT="$PWD/.dotnet"
          export DOTNET_CLI_HOME="$PWD/.dotnet-home"
          export NUGET_PACKAGES="$PWD/.nuget/packages"
          export DOTNET_MULTILEVEL_LOOKUP=0
          export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
          export DOTNET_CLI_TELEMETRY_OPTOUT=1

          export ANDROID_HOME="${android.androidsdk}/libexec/android-sdk"
          export ANDROID_SDK_ROOT="$ANDROID_HOME"
          export JAVA_HOME="${pkgs.jdk17.home}"

          export PATH="$DOTNET_ROOT:$DOTNET_ROOT/tools:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH"

          if [ ! -x "$DOTNET_ROOT/dotnet" ]; then
            echo "Run 'maui-bootstrap' once to install a writable project-local .NET ${dotnetMajor} SDK and MAUI Android workload."
          fi
        '';
      };

      mauiBuildEnv = mkMauiEnv "dotnet-maui-fhs" androidBuild;
      mauiEmulatorEnv = mkMauiEnv "dotnet-maui-emulator-fhs" androidEmulator;
    in
    {
      packages.${system} = {
        default = mauiBuildEnv;
        emulator = mauiEmulatorEnv;
      };

      devShells.${system} = {
        default = mauiBuildEnv.env;
        emulator = mauiEmulatorEnv.env;
      };
    };
}
