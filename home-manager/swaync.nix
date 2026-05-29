{ pkgs, ... }:

{
  services.swaync = {
    enable = true;
    package = pkgs.swaynotificationcenter;
    settings = {
      "$schema" = "${pkgs.swaynotificationcenter}/etc/xdg/swaync/configSchema.json";
      "ignore-gtk-theme" = true;
      "positionX" = "right";
      "positionY" = "top";
      "layer" = "overlay";
      "control-center-layer" = "overlay";
      "control-center-positionX" = "right";
      "control-center-positionY" = "top";
      "control-center-margin-top" = 8;
      "control-center-margin-right" = 8;
      "control-center-width" = 430;
      "control-center-height" = 620;
      "fit-to-screen" = false;
      "keyboard-shortcuts" = true;
      "notification-grouping" = true;
      "hide-on-clear" = false;
      "hide-on-action" = true;
      "text-empty" = "No notifications";
      "notification-visibility" = {
        "center-only" = {
          "state" = "muted";
          "app-name" = ".*";
        };
      };
      "widgets" = [
        "title"
        "dnd"
        "notifications"
      ];
      "widget-config" = {
        "title" = {
          "text" = "Notifications";
          "clear-all-button" = true;
          "button-text" = "Clear";
        };
        "dnd" = {
          "text" = "Quiet mode";
        };
        "notifications" = {
          "vexpand" = true;
        };
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        box-shadow: none;
        font-family: Iosevka Nerd Font, sans-serif;
        font-size: 13px;
      }

      .control-center {
        background: rgba(20, 22, 32, 0.96);
        border: 1px solid rgba(169, 177, 214, 0.16);
        border-radius: 8px;
        color: #c0caf5;
        padding: 10px;
      }

      .control-center-list {
        background: transparent;
      }

      .control-center .notification-row {
        outline: none;
      }

      .control-center .notification-row:focus,
      .control-center .notification-row:hover {
        background: rgba(169, 177, 214, 0.08);
        border-radius: 8px;
      }

      .notification {
        background: rgba(36, 40, 59, 0.86);
        border: 1px solid rgba(169, 177, 214, 0.12);
        border-radius: 8px;
        margin: 6px 0;
        padding: 8px;
      }

      .notification-content {
        background: transparent;
        padding: 0;
      }

      .summary {
        color: #c0caf5;
        font-weight: 700;
      }

      .body,
      .time {
        color: #a9b1d6;
      }

      .close-button {
        background: rgba(247, 118, 142, 0.16);
        border-radius: 999px;
        color: #f7768e;
        min-height: 22px;
        min-width: 22px;
      }

      .widget-title,
      .widget-dnd {
        background: rgba(36, 40, 59, 0.72);
        border: 1px solid rgba(169, 177, 214, 0.10);
        border-radius: 8px;
        margin: 0 0 8px;
        padding: 8px 10px;
      }

      .widget-title label {
        color: #c0caf5;
        font-weight: 700;
      }

      .widget-title button {
        background: rgba(247, 118, 142, 0.14);
        border-radius: 6px;
        color: #f7768e;
        padding: 4px 10px;
      }

      .widget-dnd label {
        color: #a9b1d6;
      }

      .widget-dnd switch {
        background: rgba(169, 177, 214, 0.18);
        border-radius: 999px;
      }

      .widget-dnd switch:checked {
        background: rgba(224, 175, 104, 0.42);
      }
    '';
  };
}
