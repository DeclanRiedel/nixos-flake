# My nixos flake. It will never die.

## Hosts
`vostro` is the main laptop/desktop config.
`nixos-wsl` is the WSL2 config, terminal-first: shells, tmux, nvim etc

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
