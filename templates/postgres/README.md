# PostgreSQL Nix Dev Shell

```sh
nix develop
pg-init
pg-start
createdb app
psql app
pg-stop
```

Database state lives in `.pgdata/` and socket/log files live in `.pgrun/`.

Create a backup:

```sh
pg-dump app backups/app.dump
```
