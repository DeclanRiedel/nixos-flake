{
  description = ".NET 10 development shells for console, web, Android, and MAUI projects";

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

      dotnetSdk = pkgs.dotnet-sdk_10;
      dotnetChannel = "10.0";
      targetFramework = "net10.0-android";

      commonShellHook = ''
        export DOTNET_ROOT="${dotnetSdk}"
        export DOTNET_CLI_HOME="$PWD/.dotnet-home"
        export NUGET_PACKAGES="$PWD/.nuget/packages"
        export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
        export DOTNET_CLI_TELEMETRY_OPTOUT=1
        export PATH="$DOTNET_CLI_HOME/tools:$PATH"
        mkdir -p "$DOTNET_CLI_HOME" "$NUGET_PACKAGES"
      '';

      basePackages = with pkgs; [
        dotnetSdk
        git
        icu
        openssl
      ];

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

      dotnetBootstrap = pkgs.writeShellScriptBin "dotnet-bootstrap" ''
        set -euo pipefail

        workload="''${1:-''${DOTNET_WORKLOAD:-android}}"
        channel="''${DOTNET_CHANNEL:-${dotnetChannel}}"
        mkdir -p "$PWD/.dotnet" "$PWD/.dotnet-home" "$PWD/.nuget/packages"

        if [ ! -x "$PWD/.dotnet/dotnet" ]; then
          tmp="$(mktemp -d)"
          trap 'rm -rf "$tmp"' EXIT
          ${pkgs.curl}/bin/curl -fsSL https://dot.net/v1/dotnet-install.sh -o "$tmp/dotnet-install.sh"
          ${pkgs.bash}/bin/bash "$tmp/dotnet-install.sh" \
            --channel "$channel" \
            --install-dir "$PWD/.dotnet"
        fi

        "$PWD/.dotnet/dotnet" workload install "$workload"
        "$PWD/.dotnet/dotnet" workload list
      '';

      androidBootstrap = pkgs.writeShellScriptBin "android-bootstrap" ''
        exec dotnet-bootstrap android
      '';

      mauiBootstrap = pkgs.writeShellScriptBin "maui-bootstrap" ''
        exec dotnet-bootstrap maui-android
      '';

      mobileDoctor = pkgs.writeShellScriptBin "dotnet-mobile-doctor" ''
        set -euo pipefail
        dotnet --info
        echo
        dotnet workload list
        echo
        sdkmanager --list_installed | sed -n '1,80p'
        echo
        java -version
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

      mauiNewAndroid = pkgs.writeShellScriptBin "maui-new-android" ''
        set -euo pipefail
        if [ "$#" -ne 1 ]; then
          echo "Usage: maui-new-android <ProjectName>" >&2
          exit 2
        fi

        name="$1"
        dotnet new maui -n "$name" --no-restore
        project="$name/$name.csproj"
        sed -i -E \
          's#<TargetFrameworks>[^<]+</TargetFrameworks>#<TargetFrameworks>${targetFramework}</TargetFrameworks>#' \
          "$project"
        dotnet restore "$project"

        echo "Created Android-only MAUI project: $project"
        echo "Build with: dotnet build $project -f ${targetFramework}"
      '';

      androidSmokeTest = pkgs.writeShellScriptBin "android-smoke-test" ''
        set -euo pipefail
        android-bootstrap
        workdir="$(mktemp -d -p "$PWD" android-smoke.XXXXXX)"
        trap 'rm -rf "$workdir"' EXIT
        dotnet new android -n SmokeAndroid -o "$workdir/SmokeAndroid" --no-restore
        dotnet build "$workdir/SmokeAndroid/SmokeAndroid.csproj" -f ${targetFramework}
      '';

      mauiSmokeTest = pkgs.writeShellScriptBin "maui-smoke-test" ''
        set -euo pipefail
        maui-bootstrap
        workdir="$(mktemp -d -p "$PWD" maui-smoke.XXXXXX)"
        trap 'rm -rf "$workdir"' EXIT

        dotnet new maui -n SmokeMaui -o "$workdir/SmokeMaui" --no-restore
        project="$workdir/SmokeMaui/SmokeMaui.csproj"
        sed -i -E \
          's#<TargetFrameworks>[^<]+</TargetFrameworks>#<TargetFrameworks>${targetFramework}</TargetFrameworks>#' \
          "$project"
        dotnet build "$project" -f ${targetFramework}
      '';

      mkMobileEnv = { name, android, workload }:
        pkgs.buildFHSEnv {
          inherit name;

          targetPkgs = pkgs: with pkgs; [
            android.androidsdk
            androidBootstrap
            androidNew
            androidSmokeTest
            bash
            curl
            dotnetBootstrap
            git
            glibc
            gnused
            icu
            jdk17
            mauiBootstrap
            mauiNewAndroid
            mauiSmokeTest
            mobileDoctor
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
            export DOTNET_WORKLOAD="${workload}"

            export ANDROID_HOME="${android.androidsdk}/libexec/android-sdk"
            export ANDROID_SDK_ROOT="$ANDROID_HOME"
            export JAVA_HOME="${pkgs.jdk17.home}"
            export PATH="$DOTNET_ROOT:$DOTNET_ROOT/tools:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH"

            if [ ! -x "$DOTNET_ROOT/dotnet" ]; then
              echo "Run 'dotnet-bootstrap' once to install the project-local .NET ${dotnetChannel} SDK and $DOTNET_WORKLOAD workload."
            fi
          '';
        };

      androidEnv = mkMobileEnv {
        name = "dotnet-android-fhs";
        android = androidBuild;
        workload = "android";
      };

      mauiEnv = mkMobileEnv {
        name = "dotnet-maui-fhs";
        android = androidBuild;
        workload = "maui-android";
      };

      emulatorEnv = mkMobileEnv {
        name = "dotnet-maui-emulator-fhs";
        android = androidEmulator;
        workload = "maui-android";
      };
    in
    {
      devShells.${system} = {
        default = pkgs.mkShell {
          packages = basePackages;
          shellHook = commonShellHook;
        };

        web = pkgs.mkShell {
          packages = basePackages ++ (with pkgs; [
            curl
            postgresql
            sqlite
          ]);
          shellHook = commonShellHook + ''
            export ASPNETCORE_ENVIRONMENT=Development
          '';
        };

        android = androidEnv.env;
        maui = mauiEnv.env;
        emulator = emulatorEnv.env;
      };

      packages.${system} = {
        android = androidEnv;
        maui = mauiEnv;
        emulator = emulatorEnv;
      };
    };
}
