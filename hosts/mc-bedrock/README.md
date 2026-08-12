# Minecraft Bedrock host

This host was migrated from `DeclanRiedel/mc-bedrock-nixos`.

- `default.nix` owns the machine configuration.
- `hardware-configuration.nix` came from the original repository's `master` branch.
- `server/` is the complete Minecraft Bedrock deployment.
- Persistent worlds and backups remain under `/var/lib/minecraft-bedrock` and are not stored in Git.

Deploy from this flake with:

```sh
sudo nixos-rebuild switch --flake .#mc-bedrock
```
