# My nixos flake. It will never die.

## Hosts

`vostro` is the main laptop/desktop config.
`nixos-wsl` is the WSL2 config, terminal-first: shells, tmux, nvim etc
`mc-bedrock` is the minimal headless Minecraft Bedrock server.

## Switching

Switch the current host:
```sh
./scripts/switch.sh
```

Switch an explicit host:
```sh
./scripts/switch.sh vostro
./scripts/switch.sh nixos-wsl
./scripts/switch.sh mc-bedrock
```

List available hosts:
```sh
./scripts/switch.sh --list
```
