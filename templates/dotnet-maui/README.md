# NixOS .NET MAUI Template

This template is for using MAUI Android workloads on NixOS while keeping the
mutable .NET SDK workload packs inside the project directory.

The Nix shell provides Android SDK tools, JDK 17, native libraries, and an FHS
environment. `maui-bootstrap` installs a writable .NET SDK into `.dotnet/` and
then installs the `maui-android` workload there.

## Use

```sh
nix develop
maui-bootstrap
maui-new-android MyMauiApp
dotnet build MyMauiApp/MyMauiApp.csproj -f net9.0-android
```

Use the larger emulator shell when you want Android emulator images available:

```sh
nix develop .#emulator
```

Run `maui-doctor` inside `nix develop` to print the active SDK, workload,
Android SDK, and Java state.

## Notes

- Linux is not a MAUI desktop target. This template focuses on Android builds.
- The stock `dotnet new maui` template includes iOS/Mac Catalyst target
  frameworks. Use `maui-new-android` on NixOS unless you manually edit the
  project before restore.
- iOS and Mac Catalyst still require Apple tooling on macOS.
- Windows MAUI targets require Windows tooling.
- Workload state is intentionally project-local and ignored by git.
