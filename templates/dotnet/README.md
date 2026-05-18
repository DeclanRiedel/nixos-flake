# .NET Nix Dev Shell

```sh
nix develop
dotnet --info
dotnet new console -n MyApp
dotnet test
```

This shell uses the Nix-provided .NET SDK and keeps CLI/NuGet state inside the project.
