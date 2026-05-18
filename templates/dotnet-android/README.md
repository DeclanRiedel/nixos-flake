# .NET Android NixOS Template

This template is for Android-only .NET projects on NixOS. Nix provides the Android SDK, Java, native libraries, and an FHS shell. `android-bootstrap` installs a writable project-local .NET SDK and the `android` workload.

```sh
nix develop
android-bootstrap
android-new MyAndroidApp
dotnet build MyAndroidApp/MyAndroidApp.csproj -f net9.0-android
```

Run `android-smoke-test` to create and build a temporary Android project. It uses the project-local workload state and may take a while the first time.

You can also run commands through the FHS environment without entering an
interactive shell:

```sh
nix run .# -- -c 'android-doctor'
```
