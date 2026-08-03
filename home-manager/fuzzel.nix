{ pkgs, ... }:

{
  home.file.".config/fuzzel/fuzzel.ini" = {
    source = ../config/fuzzel.ini;
    force = true;
  };

  home.file.".local/bin/fuzzel-launcher" = {
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash
      set -euo pipefail

      fuzzel="${pkgs.fuzzel}/bin/fuzzel"
      ghostty="${pkgs.ghostty}/bin/ghostty"
      jq="${pkgs.jq}/bin/jq"
      sqlite="${pkgs.sqlite}/bin/sqlite3"
      cut="${pkgs.coreutils}/bin/cut"
      floorp_profile="$HOME/.floorp/g7it090d.default-default"

      choose() {
        local prompt="$1"
        shift
        printf '%s\n' "$@" | "$fuzzel" --dmenu --prompt "$prompt"
      }

      run_shell() {
        "$ghostty" -e ${pkgs.zsh}/bin/zsh -lc "$1; exec ${pkgs.zsh}/bin/zsh"
      }

      ddg_search() {
        local query encoded
        query="$(printf '\n' | "$fuzzel" --dmenu --prompt "ddg  ")"
        [[ -n "$query" ]] || exit 0
        encoded="$(printf '%s' "$query" | "$jq" -sRr @uri)"
        exec floorp "https://duckduckgo.com/?q=$encoded"
      }

      floorp_history() {
        local places item url
        places="$floorp_profile/places.sqlite"
        [[ -r "$places" ]] || exit 0

        item="$("$sqlite" -readonly "$places" \
          "SELECT replace(CASE WHEN title IS NULL OR length(title) = 0 THEN url ELSE title END, char(10), ' ') || char(9) || url
           FROM moz_places
           WHERE url LIKE 'http%'
           ORDER BY last_visit_date DESC
           LIMIT 200;" \
          | "$fuzzel" --dmenu --prompt "hist  ")"
        [[ -n "$item" ]] || exit 0
        url="$(printf '%s' "$item" | "$cut" -f2-)"
        exec floorp "$url"
      }

      item="$(choose "run  " \
        "app Floorp" \
        "app Floorp private" \
        "web DuckDuckGo search" \
        "web Floorp history" \
        "app Zed" \
        "app VS Code" \
        "app Obsidian" \
        "app Vesktop" \
        "app Telegram" \
        "app Bitwarden" \
        "app Spotify" \
        "app Settings" \
        "app All apps" \
        "dev NixOS flake in Zed" \
        "dev Work folder in Zed" \
        "dev Codex in flake" \
        "dev Opencode in flake" \
        "dev Lazygit in flake" \
        "dev Tmux attach" \
        "open Files" \
        "open Downloads" \
        "open NixOS flake" \
        "open Yazi home" \
        "open Yazi work" \
        "open Images" \
        "open PDF viewer" \
        "open MPV" \
        "cmd Rebuild NixOS" \
        "cmd Check flake" \
        "cmd Update flake" \
        "cmd Git status" \
        "cmd Btop" \
        "cmd Clipboard history" \
        "sys Lock" \
        "sys Logout menu" \
        "sys Volume" \
        "sys Bluetooth" \
        "sys Passwords" \
        "sys Screenshot region")"

      case "$item" in
        "app Floorp") exec floorp ;;
        "app Floorp private") exec floorp --private-window ;;
        "web DuckDuckGo search") ddg_search ;;
        "web Floorp history") floorp_history ;;
        "app Zed") exec zeditor ;;
        "app VS Code") exec code ;;
        "app Obsidian") exec obsidian ;;
        "app Vesktop") exec vesktop ;;
        "app Telegram") exec telegram-desktop ;;
        "app Bitwarden") exec bitwarden ;;
        "app Spotify") run_shell 'spotify_player' ;;
        "app Settings") exec xfce4-settings-manager ;;
        "app All apps") exec "$fuzzel" ;;
        "dev NixOS flake in Zed") exec zeditor "$HOME/.nixos" ;;
        "dev Work folder in Zed") exec zeditor "$HOME/work" ;;
        "dev Codex in flake") run_shell 'cd "$HOME/.nixos" && codex --yolo' ;;
        "dev Opencode in flake") run_shell 'cd "$HOME/.nixos" && opencode' ;;
        "dev Lazygit in flake") run_shell 'cd "$HOME/.nixos" && lazygit' ;;
        "dev Tmux attach") run_shell 'tmux attach || tmux new -s main' ;;
        "open Files") exec thunar "$HOME" ;;
        "open Downloads") exec thunar "$HOME/Downloads" ;;
        "open NixOS flake") exec thunar "$HOME/.nixos" ;;
        "open Yazi home") run_shell 'yazi "$HOME"' ;;
        "open Yazi work") run_shell 'yazi "$HOME/work"' ;;
        "open Images") exec imv "$HOME" ;;
        "open PDF viewer") exec zathura ;;
        "open MPV") exec mpv ;;
        "cmd Rebuild NixOS") run_shell 'cd "$HOME/.nixos" && sudo nixos-rebuild switch --flake .#vostro' ;;
        "cmd Check flake") run_shell 'cd "$HOME/.nixos" && nix flake check' ;;
        "cmd Update flake") run_shell 'cd "$HOME/.nixos" && nix flake update' ;;
        "cmd Git status") run_shell 'cd "$HOME/.nixos" && git status && git log --oneline -10' ;;
        "cmd Btop") run_shell 'btop' ;;
        "cmd Clipboard history") cliphist list | "$fuzzel" --dmenu --prompt "clip  " | cliphist decode | wl-copy ;;
        "sys Lock") exec hyprlock ;;
        "sys Logout menu") exec wlogout ;;
        "sys Volume") exec pavucontrol ;;
        "sys Bluetooth") exec blueman-manager ;;
        "sys Passwords") exec seahorse ;;
        "sys Screenshot region") exec hyprshot -m region -o "$HOME/Media/Screenshots/" -z -s ;;
      esac
    '';
  };
}
