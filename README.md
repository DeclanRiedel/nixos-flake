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
    - keybinds
do I want glyphs in my font? idk, fix tokyonight theme to fit stylix/base16 font colours inside ghostty conf

tmux config + plugins (auto resurrect if that exists) + rice to make nicer + neovim integration (already have plugin)

hyprcursor 
nixvim yearly config
waybar vs hyprpanel better tray for waybar // overhaul 
replace fuzzel with rofi => search, kv item-icon_path, tmux_sessions etc
investigate stow vs how nixos works




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
