{ pkgsCodex, ... }:

{
  environment.systemPackages = [
    pkgsCodex.opencode
    pkgsCodex.codex
    pkgsCodex.claude-code
  ];
}
