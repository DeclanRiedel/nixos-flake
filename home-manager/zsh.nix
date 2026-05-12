{ config, ... }:

let
  wt = "${config.programs.worktrunk.package}/bin/wt";
in
{
  programs.zsh.initContent = ''
    #used for x11 forwarding on windows?
    export DISPLAY=:0.0

    # Initialize in the current project
    nix-init() {
        if [ -z "$1" ]; then
            echo "Usage: nix-init <environment>"
            return 1
        fi
        nix flake init --template "https://flakehub.com/f/the-nix-way/dev-templates/*#$1"
    }

    # Create a new project
    nix-new() {
        if [ -z "$1" ] || [ -z "$2" ]; then
            echo "Usage: nix-new <environment> <project-directory>"
            return 1
        fi
        nix flake new --template "https://flakehub.com/f/the-nix-way/dev-templates/*#$1" "$2"
    }
    # to have nix-shell respect $SHELL 
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
        if [ -z "$1" ]; then
            echo "Usage: wtc <branch>"
            return 1
        fi

        local branch="$1"
        local old_branch before_stash after_stash did_stash

        old_branch="$(git branch --show-current)" || return
        if [ -z "$old_branch" ]; then
            echo "wtc: could not determine current branch"
            return 1
        fi

        before_stash="$(git rev-parse -q --verify refs/stash 2>/dev/null || true)"
        git stash push -u || return
        after_stash="$(git rev-parse -q --verify refs/stash 2>/dev/null || true)"

        did_stash=0
        if [ "$after_stash" != "$before_stash" ]; then
            did_stash=1
        fi

        ${wt} switch --create "$branch" --base=@ || return

        if [ "$did_stash" -eq 1 ]; then
            git stash pop || return
        fi

        ${wt} step copy-ignored --from "$old_branch" --to "$branch"
    }
  '';
}
