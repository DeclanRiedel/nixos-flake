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

      choose() {
        local prompt="$1"
        shift
        printf '%s\n' "$@" | "$fuzzel" --dmenu --prompt "$prompt"
      }

      run_shell() {
        "$ghostty" -e ${pkgs.zsh}/bin/zsh -lc "$1; exec ${pkgs.zsh}/bin/zsh"
      }

      group="$(choose "group  " \
        "󰀻 Apps" \
        "󰅩 Dev / Agents" \
        "󰈙 View / Open" \
        "󰘳 Commands" \
        "󰒓 System" \
        "󰀻 All apps")"

      case "$group" in
        "󰀻 Apps")
          item="$(choose "apps  " \
            "󰈹 Floorp" \
            "󰈹 Floorp private" \
            "󰨞 Zed" \
            "󰊢 VS Code" \
            "󰊢 Obsidian" \
            "󰙯 Vesktop" \
            "󰌾 Bitwarden" \
            "󰒓 Settings")"
          case "$item" in
            "󰈹 Floorp") exec floorp ;;
            "󰈹 Floorp private") exec floorp --private-window ;;
            "󰨞 Zed") exec zeditor ;;
            "󰊢 VS Code") exec code ;;
            "󰊢 Obsidian") exec obsidian ;;
            "󰙯 Vesktop") exec vesktop ;;
            "󰌾 Bitwarden") exec bitwarden ;;
            "󰒓 Settings") exec xfce4-settings-manager ;;
          esac
          ;;

        "󰅩 Dev / Agents")
          item="$(choose "dev  " \
            "󰱼 NixOS flake in Zed" \
            "󱓞 Work folder in Zed" \
            "󰙨 Codex in flake" \
            "󰚩 Opencode in flake" \
            "󰊢 Lazygit in flake" \
            "󰓓 Tmux attach")"
          case "$item" in
            "󰱼 NixOS flake in Zed") exec zeditor "$HOME/.nixos" ;;
            "󱓞 Work folder in Zed") exec zeditor "$HOME/work" ;;
            "󰙨 Codex in flake") run_shell 'cd "$HOME/.nixos" && codex --yolo' ;;
            "󰚩 Opencode in flake") run_shell 'cd "$HOME/.nixos" && opencode' ;;
            "󰊢 Lazygit in flake") run_shell 'cd "$HOME/.nixos" && lazygit' ;;
            "󰓓 Tmux attach") run_shell 'tmux attach || tmux new -s main' ;;
          esac
          ;;

        "󰈙 View / Open")
          item="$(choose "view  " \
            "󰉋 Files" \
            "󰉋 Downloads" \
            "󰉋 NixOS flake" \
            "󰈙 Yazi home" \
            "󰈙 Yazi work" \
            "󰋩 Images" \
            "󰎁 PDF viewer" \
            "󰕧 MPV")"
          case "$item" in
            "󰉋 Files") exec thunar "$HOME" ;;
            "󰉋 Downloads") exec thunar "$HOME/Downloads" ;;
            "󰉋 NixOS flake") exec thunar "$HOME/.nixos" ;;
            "󰈙 Yazi home") run_shell 'yazi "$HOME"' ;;
            "󰈙 Yazi work") run_shell 'yazi "$HOME/work"' ;;
            "󰋩 Images") exec imv "$HOME" ;;
            "󰎁 PDF viewer") exec zathura ;;
            "󰕧 MPV") exec mpv ;;
          esac
          ;;

        "󰘳 Commands")
          item="$(choose "cmd  " \
            "󱁤 Rebuild NixOS" \
            "󰁨 Check flake" \
            "󰚰 Update flake" \
            "󰊢 Git status" \
            "󰍛 Btop" \
            "󰔛 Clipboard history")"
          case "$item" in
            "󱁤 Rebuild NixOS") run_shell 'cd "$HOME/.nixos" && sudo nixos-rebuild switch --flake .#vostro' ;;
            "󰁨 Check flake") run_shell 'cd "$HOME/.nixos" && nix flake check' ;;
            "󰚰 Update flake") run_shell 'cd "$HOME/.nixos" && nix flake update' ;;
            "󰊢 Git status") run_shell 'cd "$HOME/.nixos" && git status && git log --oneline -10' ;;
            "󰍛 Btop") run_shell 'btop' ;;
            "󰔛 Clipboard history") cliphist list | "$fuzzel" --dmenu --prompt "clip  " | cliphist decode | wl-copy ;;
          esac
          ;;

        "󰒓 System")
          item="$(choose "sys  " \
            "󰌾 Lock" \
            "󰍃 Logout menu" \
            "󰕾 Volume" \
            "󰂯 Bluetooth" \
            "󰌆 Passwords" \
            "󰅐 Screenshot region")"
          case "$item" in
            "󰌾 Lock") exec hyprlock ;;
            "󰍃 Logout menu") exec wlogout ;;
            "󰕾 Volume") exec pavucontrol ;;
            "󰂯 Bluetooth") exec blueman-manager ;;
            "󰌆 Passwords") exec seahorse ;;
            "󰅐 Screenshot region") exec hyprshot -m region -o "$HOME/Media/Screenshots/" -z -s ;;
          esac
          ;;

        "󰀻 All apps")
          exec "$fuzzel"
          ;;
      esac
    '';
  };
}
