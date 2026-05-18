# NixOS .NET MAUI Template

This template is for using MAUI Android workloads on NixOS while keeping the
mutable .NET SDK workload packs inside the project directory.

The default Nix shell provides Android SDK build tools, JDK 17, native
libraries, and an FHS environment. It does not put Android or MAUI workloads in
the host system closure. `maui-bootstrap` installs a writable .NET SDK into
`.dotnet/` and then installs the `maui-android` workload there.

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

Run a full temporary project build when you want to prove the workload is
usable:

```sh
maui-smoke-test
```

You can also run commands through the FHS environment without entering an
interactive shell:

```sh
nix run .# -- -c 'maui-doctor'
```

The smoke test calls `maui-bootstrap`, creates a temporary MAUI project, rewrites
it to `net9.0-android`, and builds it.

Override the project-local SDK channel or workload when you need to test a new
.NET release:

```sh
DOTNET_CHANNEL=10.0 MAUI_WORKLOAD=maui-android maui-bootstrap
```

## Notes

- Linux is not a MAUI desktop target. This template focuses on Android builds.
- The emulator shell is intentionally separate because Android system images
  are much heavier than the build toolchain.
- The stock `dotnet new maui` template includes iOS/Mac Catalyst target
  frameworks. Use `maui-new-android` on NixOS unless you manually edit the
  project before restore.
- iOS and Mac Catalyst still require Apple tooling on macOS.
- Windows MAUI targets require Windows tooling.
- Workload state is intentionally project-local and ignored by git.
