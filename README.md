# My nixos flake. It will never die.

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
    - bg from hyprland
    - fonts
    - keybinds
    - remove close confirm 
    - size popup on start

tmux config + plugins (auto resurrect if that exists) + rice to make nicer + neovim integration (already have plugin)

hyprcursor 
nixvim yearly config
waybar vs hyprpanel better tray for waybar // overhaul 
replace fuzzel with rofi => search, kv item-icon_path, tmux_sessions etc
investigate stow vs how nixos works 
