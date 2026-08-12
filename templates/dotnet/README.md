# .NET 10 Nix development template

One template provides project-scoped shells for ordinary .NET, ASP.NET Core,
Android, and MAUI Android work. Initialize it with:

```sh
nix flake init -t /path/to/.nixos#dotnet
```

## Console, libraries, tests, and F#

```sh
nix develop
dotnet --info
dotnet new console -n MyApp
dotnet test
```

## ASP.NET Core

```sh
nix develop .#web
dotnet new webapi -n MyApi
dotnet run --project MyApi
```

The web shell also includes PostgreSQL and SQLite clients. Project-local .NET
tools are placed on `PATH`:

```sh
dotnet new tool-manifest
dotnet tool install dotnet-ef
dotnet ef --help
```

## Android

Android workloads need a writable SDK, so the mobile shells keep .NET and its
workloads inside the project instead of modifying the Nix store:

```sh
nix develop .#android
android-bootstrap
android-new MyAndroidApp
dotnet build MyAndroidApp/MyAndroidApp.csproj -f net10.0-android
```

Use `android-smoke-test` for a temporary end-to-end build and
`dotnet-mobile-doctor` to inspect the SDKs.

## MAUI Android

```sh
nix develop .#maui
maui-bootstrap
maui-new-android MyMauiApp
dotnet build MyMauiApp/MyMauiApp.csproj -f net10.0-android
```

For an Android emulator image, use the larger shell:

```sh
nix develop .#emulator
```

The mobile environments can also run without entering an interactive shell:

```sh
nix run .#maui -- -c 'dotnet-mobile-doctor'
```

Linux is not a MAUI desktop target. These shells support MAUI Android; Apple
targets still require macOS tooling and Windows targets require Windows.
