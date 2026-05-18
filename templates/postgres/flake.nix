{
  description = "PostgreSQL development shell";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      pgInit = pkgs.writeShellScriptBin "pg-init" ''
        set -euo pipefail

        mkdir -p "$PGDATA" "$PGHOST"

        if [ ! -s "$PGDATA/PG_VERSION" ]; then
          initdb --encoding=UTF8 --locale=C.UTF-8 "$PGDATA"
          {
            printf "%s\n" "listen_addresses = '127.0.0.1'"
            printf "%s\n" "unix_socket_directories = '$PGHOST'"
            printf "%s\n" "port = $PGPORT"
          } >> "$PGDATA/postgresql.conf"
        fi
      '';

      pgStart = pkgs.writeShellScriptBin "pg-start" ''
        set -euo pipefail

        pg-init
        pg_ctl -D "$PGDATA" -l "$PGHOST/postgres.log" start
      '';

      pgStop = pkgs.writeShellScriptBin "pg-stop" ''
        set -euo pipefail

        pg_ctl -D "$PGDATA" stop
      '';

      pgDump = pkgs.writeShellScriptBin "pg-dump" ''
        set -euo pipefail

        if [ "$#" -ne 2 ]; then
          echo "Usage: pg-dump <database> <output.dump>" >&2
          exit 2
        fi

        mkdir -p "$(dirname "$2")"
        pg_dump --format=custom --file="$2" "$1"
      '';
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.postgresql_17
          pgInit
          pgStart
          pgStop
          pgDump
        ];

        shellHook = ''
          export PGDATA="$PWD/.pgdata"
          export PGHOST="$PWD/.pgrun"
          export PGPORT="54329"
          export DATABASE_URL="postgresql:///$USER?host=$PGHOST&port=$PGPORT"
          mkdir -p "$PGHOST"
        '';
      };
    };
}
