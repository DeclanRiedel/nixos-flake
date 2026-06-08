{ pkgs, ... }:

let
  bellIcon = pkgs.writeText "swaync-bell.svg" ''
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#7dcfff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
      <path d="M10 5a2 2 0 1 1 4 0a7 7 0 0 1 4 6v3a4 4 0 0 0 2 3h-16a4 4 0 0 0 2 -3v-3a7 7 0 0 1 4 -6" />
      <path d="M9 17v1a3 3 0 0 0 6 0v-1" />
    </svg>
  '';
  bellOffIcon = pkgs.writeText "swaync-bell-off.svg" ''
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#e0af68" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
      <path d="M9.346 5.353c.21 -.129 .428 -.246 .654 -.353a2 2 0 1 1 4 0a7 7 0 0 1 4 6v3m-1 3h-13a4 4 0 0 0 2 -3v-3a6.996 6.996 0 0 1 1.273 -3.707" />
      <path d="M9 17v1a3 3 0 0 0 6 0v-1" />
      <path d="M3 3l18 18" />
    </svg>
  '';
  trashIcon = pkgs.writeText "swaync-trash.svg" ''
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#f7768e" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
      <path d="M4 7l16 0" />
      <path d="M10 11l0 6" />
      <path d="M14 11l0 6" />
      <path d="M5 7l1 12a2 2 0 0 0 2 2h8a2 2 0 0 0 2 -2l1 -12" />
      <path d="M9 7v-3a1 1 0 0 1 1 -1h4a1 1 0 0 1 1 1v3" />
    </svg>
  '';
  closeIcon = pkgs.writeText "swaync-close.svg" ''
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#f7768e" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
      <path d="M18 6l-12 12" />
      <path d="M6 6l12 12" />
    </svg>
  '';
  alertIcon = pkgs.writeText "swaync-alert.svg" ''
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#f7768e" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
      <path d="M12 9v4" />
      <path d="M10.363 3.591l-8.106 13.534a1.914 1.914 0 0 0 1.636 2.871h16.214a1.914 1.914 0 0 0 1.636 -2.87l-8.106 -13.536a1.914 1.914 0 0 0 -3.274 0" />
      <path d="M12 16h.01" />
    </svg>
  '';
in
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
        background: rgba(12, 14, 22, 0.98);
        border: 1px solid rgba(125, 207, 255, 0.20);
        border-radius: 8px;
        color: #c0caf5;
        padding: 12px;
      }

      .control-center-list {
        background: transparent;
      }

      .control-center .notification-row {
        outline: none;
      }

      .control-center .notification-row:focus,
      .control-center .notification-row:hover {
        background: rgba(125, 207, 255, 0.08);
        border-radius: 8px;
      }

      .notification {
        background: rgba(28, 31, 46, 0.92);
        border: 1px solid rgba(169, 177, 214, 0.13);
        border-radius: 8px;
        margin: 7px 0;
        padding: 9px;
      }

      .notification.normal {
        background-image: url("${bellIcon}");
        background-position: 12px 12px;
        background-repeat: no-repeat;
        background-size: 18px 18px;
      }

      .notification.critical {
        background-image: url("${alertIcon}");
        background-position: 12px 12px;
        background-repeat: no-repeat;
        background-size: 18px 18px;
      }

      .notification-content {
        background: transparent;
        padding: 0 0 0 28px;
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
        background-color: rgba(247, 118, 142, 0.14);
        background-image: url("${closeIcon}");
        background-position: center;
        background-repeat: no-repeat;
        background-size: 13px 13px;
        border-radius: 999px;
        min-height: 22px;
        min-width: 22px;
      }

      .widget-title,
      .widget-dnd {
        background-color: rgba(28, 31, 46, 0.84);
        border: 1px solid rgba(125, 207, 255, 0.12);
        border-radius: 8px;
        margin: 0 0 8px;
        padding: 9px 10px 9px 38px;
      }

      .widget-title {
        background-image: url("${bellIcon}");
        background-position: 12px center;
        background-repeat: no-repeat;
        background-size: 18px 18px;
      }

      .widget-dnd {
        background-image: url("${bellOffIcon}");
        background-position: 12px center;
        background-repeat: no-repeat;
        background-size: 18px 18px;
      }

      .widget-title label {
        color: #c0caf5;
        font-weight: 700;
      }

      .widget-title button {
        background-color: rgba(247, 118, 142, 0.14);
        background-image: url("${trashIcon}");
        background-position: 8px center;
        background-repeat: no-repeat;
        background-size: 14px 14px;
        border-radius: 6px;
        color: #f7768e;
        padding: 4px 10px 4px 28px;
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
