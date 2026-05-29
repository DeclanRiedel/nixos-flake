{ config, ... }:

let
  wt = "${config.programs.worktrunk.package}/bin/wt";
in
{
  programs.zsh.initContent = ''
    export DISPLAY=:0.0

    nix-init() {
        if [ -z "$1" ]; then
            echo "Usage: nix-init <environment>"
            return 1
        fi
        nix flake init --template "https://flakehub.com/f/the-nix-way/dev-templates/*#$1"
    }

    nix-new() {
        if [ -z "$1" ] || [ -z "$2" ]; then
            echo "Usage: nix-new <environment> <project-directory>"
            return 1
        fi
        nix flake new --template "https://flakehub.com/f/the-nix-way/dev-templates/*#$1" "$2"
    }

    alias nix-shell='nix-shell --run $SHELL'
    path=("${config.programs.worktrunk.package}/bin" $path)

    nix() {
        if [[ $1 == "develop" ]]; then
            shift
            command nix develop -c $SHELL "$@"
        else
            command nix "$@"
        fi
    }

    wtc() {
        if [[ $# -lt 1 ]]; then
            echo "usage: wtc <branch> [wt switch args...]" >&2
            return 2
        fi

        local branch="$1"
        shift

        local root source_branch tmp target
        root="$(git rev-parse --show-toplevel)" || return
        source_branch="$(git branch --show-current)" || return

        if [[ -z "$source_branch" ]]; then
            echo "wtc: detached HEAD is not supported" >&2
            return 1
        fi

        tmp="$(mktemp -d)" || return

        (
            cd "$root" || exit
            git diff --binary HEAD > "$tmp/wip.patch"
            git ls-files --others --exclude-standard -z > "$tmp/untracked.zlist"
            {
                find . \
                    \( -path '*/bin/*' -o -path '*/obj/*' \) -prune -o \
                    -type f -name 'appsettings*.json' -printf '%P\0' |
                    while IFS= read -r -d "" relpath; do
                        git check-ignore -q -- "$relpath" && printf '%s\0' "$relpath"
                    done
                true
            } > "$tmp/ignored-local-config.zlist"
        ) || return

        ${wt} switch --create "$branch" --base=@ "$@"
        local switch_status=$?
        if [[ $switch_status -ne 0 ]]; then
            return $switch_status
        fi

        target="$(
            git worktree list --porcelain |
            awk -v b="refs/heads/''${branch}" '
                /^worktree / { path=substr($0, 10) }
                /^branch / && substr($0, 8) == b { print path; exit }
            '
        )"

        if [[ -z "$target" ]]; then
            echo "wtc: could not find worktree for ''${branch}" >&2
            return 1
        fi

        if [[ -s "$tmp/wip.patch" ]]; then
            (cd "$target" && git apply "$tmp/wip.patch") || return
        fi

        if [[ -s "$tmp/untracked.zlist" ]]; then
            (cd "$root" && tar --null -T "$tmp/untracked.zlist" -cf -) |
                (cd "$target" && tar -xf -) || return
        fi

        ${wt} step copy-ignored --from "$source_branch" --to "$branch" || return

        if [[ -s "$tmp/ignored-local-config.zlist" ]]; then
            (cd "$root" && tar --null -T "$tmp/ignored-local-config.zlist" -cf -) |
                (cd "$target" && tar --overwrite -xf -) || return
        fi

        rm -rf "$tmp"
    }
  '';
}
