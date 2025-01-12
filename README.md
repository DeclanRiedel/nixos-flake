# nixos-flake

My nixos flake. It will receive atomic upgrades until the day I die

## Structure breakdown

config/ -> config files to be linked by hm
misc/ -> generic nixos shit, doesn't get touched ever
wall/ -> wallpapers for hyprlock, sddm and swww
home-manager/ -> configs for home-manager ran items note: zsh has part of the config here.
modules/ -> nix configured files, zsh alias here
scripts/ -> shell scripts stored here.

## Changes to be made

change all absolute paths to relative.
figure out sddm pfp
merge nixvim config with nixos config
