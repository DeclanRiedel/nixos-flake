# My nixos flake. It will never die.

## Hosts

`vostro` is the main laptop/desktop config. It includes Hyprland, Waybar,
SDDM, desktop apps, media tools, and the full riced GUI setup.

`nixos-wsl` is the WSL2 config. It is terminal-first: shells, tmux, editor,
agentic coding tools, language servers, formatters, and CLI utilities. It does
not install GUI desktop apps or pretend WSL is a Linux desktop.

## Switching

Switch the current host:

```sh
./scripts/switch.sh
```

Switch an explicit host:

```sh
./scripts/switch.sh vostro
./scripts/switch.sh nixos-wsl
```

List available hosts:

```sh
./scripts/switch.sh --list
```
