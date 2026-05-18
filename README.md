# My nixos flake. It will never die.

## Daily commands

Check the flake before switching:

```sh
./scripts/check.sh
```

Rebuild the current host from this checkout:

```sh
./scripts/switch.sh
```

Build the Vostro config without switching:

```sh
nix build .#nixosConfigurations.vostro.config.system.build.toplevel
```

Generate encrypted password hash secrets:

```sh
./scripts/generate-secret-passwords.sh
```

Update inputs and commit the lockfile:

```sh
nix flake update
nix flake check
git add flake.lock
git commit -m "chore: update flake inputs"
```

Format Nix files:

```sh
nix fmt
```

## Flake templates

This repo also exposes editable project templates:

| Template | Use |
| --- | --- |
| `c-cpp` | C/C++ with GCC, Clang tools, CMake, Ninja, pkg-config, GDB, and Valgrind |
| `dotnet` | .NET console, library, test, and F#-friendly SDK work |
| `dotnet-android` | Android-only .NET workload projects on NixOS |
| `dotnet-maui` | MAUI Android builds on NixOS with writable project-local workloads |
| `dotnet-web` | ASP.NET Core/API work with project-local CLI/NuGet state |
| `go` | Go with gopls, gotools, golangci-lint, and Delve |
| `latex` | LaTeX with TeX Live, latexmk, chktex, and PDF build helpers |
| `node` | Node.js with pnpm, yarn, bun, TypeScript, eslint, and prettier |
| `postgres` | PostgreSQL with project-local database state and helper scripts |
| `python` | Python with uv, ruff, pyright, pytest, and project `.venv` defaults |
| `rust` | Rust with cargo, rustfmt, clippy, rust-analyzer, bacon, and nextest |

Create a project from any template:

```sh
nix flake init -t github:DeclanRiedel/nixos-flake#dotnet
nix flake new -t github:DeclanRiedel/nixos-flake#rust ./my-rust-app
```

List and create templates from this checkout:

```sh
./scripts/new-dev-template.sh --list
./scripts/new-dev-template.sh dotnet-web ./my-api
```

Create a new MAUI Android project from the reusable shell:

```sh
nix flake init -t github:DeclanRiedel/nixos-flake#dotnet-maui
nix develop
maui-bootstrap
maui-new-android MyMauiApp
dotnet build MyMauiApp/MyMauiApp.csproj -f net9.0-android
```

Use the heavier emulator shell only when emulator images are needed:

```sh
nix develop .#emulator
```

Run a full MAUI Android workload smoke test from inside that shell:

```sh
maui-smoke-test
```

Run the heavier MAUI template smoke test from this checkout:

```sh
./scripts/test-maui-template.sh
```

## Structure breakdown
config/ => sourced config files destination, called from home-manager/ 
home-manager/ => call config files using home-manager
misc/ => firmware settings
modules/ => where all packages are + ones defined through nix
nixvim/ => neovim config via nix
scripts/ =>
server/ => src & nix config for different sites I host (look at .gitignore)
wall/ => wallpapers for home, sddm & hyprlock 

## todo:
ghostty config
    - keybinds
do I want glyphs in my font? idk, fix tokyonight theme to fit stylix/base16 font colours inside ghostty conf

tmux config + plugins (auto resurrect if that exists) + rice to make nicer + neovim integration (already have plugin)

hyprcursor 
nixvim yearly config
waybar vs hyprpanel better tray for waybar // overhaul 
replace fuzzel with rofi => search, kv item-icon_path, tmux_sessions etc
investigate stow vs how nixos works

## to rice;
grub
zathura
tmux
yazi/ranger
fuzzel 
put nixvim in flake as home-manager managed


## font from kitty
kitty --debug-font-fallback 
[0.198] Text fonts:
[0.198]   Normal: DejaVuSansMono: /nix/store/q768mcf5k3qxx6nva7vvbkrd9hffxvwn-dejavu-fonts-2.37/share/fonts/truetype/DejaVuSansMono.ttf:0
Features: ()
[0.198]   Bold: DejaVuSansMono-Bold: /nix/store/q768mcf5k3qxx6nva7vvbkrd9hffxvwn-dejavu-fonts-2.37/share/fonts/truetype/DejaVuSansMono-Bold.ttf:0
Features: ()
[0.198]   Italic: DejaVuSansMono-Oblique: /nix/store/q768mcf5k3qxx6nva7vvbkrd9hffxvwn-dejavu-fonts-2.37/share/fonts/truetype/DejaVuSansMono-Oblique.ttf:0
Features: ()
[0.198]   Bold-Italic: DejaVuSansMono-BoldOblique: /nix/store/q768mcf5k3qxx6nva7vvbkrd9hffxvwn-dejavu-fonts-2.37/share/fonts/truetype/DejaVuSansMono-BoldOblique.ttf:0
