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
  '';
}
