# ASP.NET Core Nix Dev Shell

```sh
nix develop
dotnet new webapi -n MyApi
dotnet run --project MyApi
```

Project-local CLI/NuGet state is used. Local dotnet tools install into `.dotnet-home/tools`, which is already on `PATH`.

```sh
dotnet tool install --local dotnet-ef
dotnet ef --help
```
