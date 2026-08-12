# Machine server configuration

This directory contains services deployed only by the `machine` host.

- `default.nix` lists the sites that are currently enabled.
- Site modules use the domain as their filename, for example `search-google-com.nix`.
- `src/` contains separately managed production repositories and is ignored by Git.
