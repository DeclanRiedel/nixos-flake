# My nixos flake. It will never die.

## Daily commands

Check the flake before switching:

```sh
./scripts/check.sh
```

Rebuild the current host from this checkout:

```sh
sudo nixos-rebuild switch --flake .#$(hostname)
```

Build the Vostro config without switching:

```sh
nix build .#nixosConfigurations.vostro.config.system.build.toplevel
```

Generate local password hash files used by `hashedPasswordFile`:

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

## MAUI template

Create a new project from the reusable MAUI Android shell:

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
