{ pkgs, ... }:

let
  symbolicIcons = "${pkgs.adwaita-icon-theme}/share/icons/Adwaita/symbolic";
  bellIcon = "${symbolicIcons}/legacy/preferences-system-notifications-symbolic.svg";
  bellOffIcon = "${symbolicIcons}/status/notifications-disabled-symbolic.svg";
  trashIcon = "${symbolicIcons}/actions/edit-delete-symbolic.svg";
  closeIcon = "${symbolicIcons}/ui/window-close-symbolic.svg";
  alertIcon = "${symbolicIcons}/status/dialog-warning-symbolic.svg";
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
      "control-center-margin-top" = 14;
      "control-center-margin-right" = 14;
      "control-center-width" = 440;
      "control-center-height" = 680;
      "notification-window-width" = 440;
      "notification-body-image-height" = 180;
      "notification-body-image-width" = 360;
      "transition-time" = 160;
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
        font-family: Iosevka Nerd Font, sans-serif;
        font-size: 14px;
      }

      notificationwindow,
      blankwindow,
      .floating-notifications {
        background: transparent;
      }

      .control-center {
        background: rgba(11, 14, 20, 0.97);
        border: 1px solid rgba(89, 194, 255, 0.20);
        border-radius: 18px;
        box-shadow: 0 18px 46px rgba(0, 0, 0, 0.48);
        color: #bfbdb6;
        padding: 14px;
      }

      .control-center .control-center-list,
      .control-center .control-center-list-placeholder {
        background: transparent;
      }

      .notification-row {
        background: transparent;
        outline: none;
      }

      .notification-row .notification-background {
        padding: 6px 8px;
      }

      .notification-row .notification-background .notification {
        background: rgba(19, 23, 33, 0.98);
        border: 1px solid rgba(191, 189, 182, 0.12);
        border-radius: 14px;
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.34);
        padding: 0;
      }

      .notification-row .notification-background .notification.normal {
        background-image: url("${bellIcon}");
        background-position: 14px 14px;
        background-repeat: no-repeat;
        background-size: 22px 22px;
      }

      .notification-row .notification-background .notification.critical {
        border-color: rgba(255, 51, 102, 0.42);
        background-image: url("${alertIcon}");
        background-position: 14px 14px;
        background-repeat: no-repeat;
        background-size: 22px 22px;
      }

      .notification-row .notification-default-action {
        background: transparent;
        border-radius: 14px;
        color: #bfbdb6;
        padding: 10px 12px;
      }

      .notification-row .notification-default-action:hover {
        background: rgba(89, 194, 255, 0.07);
      }

      .notification-row .notification-content {
        background: transparent;
        padding: 0 0 0 30px;
      }

      .notification-row .notification-content .image {
        -gtk-icon-size: 56px;
        border-radius: 10px;
        margin: 4px 8px 4px 4px;
      }

      .notification-row .summary {
        color: #e6e1cf;
        font-size: 15px;
        font-weight: 700;
      }

      .notification-row .body {
        color: #bfbdb6;
        font-size: 14px;
      }

      .notification-row .time {
        color: #6c7380;
        font-size: 12px;
        margin-right: 30px;
      }

      .close-button {
        background-color: rgba(255, 51, 102, 0.12);
        background-image: url("${closeIcon}");
        background-position: center;
        background-repeat: no-repeat;
        background-size: 14px 14px;
        border-radius: 999px;
        box-shadow: none;
        margin: 10px 10px 0 0;
        min-height: 26px;
        min-width: 26px;
        padding: 0;
      }

      .close-button:hover {
        background-color: rgba(255, 51, 102, 0.24);
      }

      .widget-title,
      .widget-dnd {
        background-color: rgba(19, 23, 33, 0.92);
        border: 1px solid rgba(89, 194, 255, 0.12);
        border-radius: 12px;
        margin: 0 0 10px;
        padding: 11px 12px 11px 44px;
      }

      .widget-title {
        background-image: url("${bellIcon}");
        background-position: 14px center;
        background-repeat: no-repeat;
        background-size: 22px 22px;
      }

      .widget-dnd {
        background-image: url("${bellOffIcon}");
        background-position: 14px center;
        background-repeat: no-repeat;
        background-size: 22px 22px;
      }

      .widget-title label {
        color: #e6e1cf;
        font-weight: 700;
      }

      .widget-title button {
        background-color: rgba(255, 51, 102, 0.12);
        background-image: url("${trashIcon}");
        background-position: 10px center;
        background-repeat: no-repeat;
        background-size: 16px 16px;
        border-radius: 9px;
        color: #ff3366;
        padding: 6px 12px 6px 34px;
      }

      .widget-title button:hover {
        background-color: rgba(255, 51, 102, 0.22);
      }

      .widget-dnd label {
        color: #bfbdb6;
      }

      .widget-dnd switch {
        background: rgba(108, 115, 128, 0.30);
        border-radius: 999px;
        min-height: 24px;
        min-width: 44px;
      }

      .widget-dnd switch:checked {
        background: rgba(255, 143, 64, 0.70);
      }

      .notification-action > button,
      .inline-reply-button,
      .inline-reply-entry {
        background: rgba(89, 194, 255, 0.10);
        border: 1px solid rgba(89, 194, 255, 0.18);
        border-radius: 9px;
        color: #e6e1cf;
        margin: 4px;
        padding: 7px 10px;
      }

      .notification-action > button:hover,
      .inline-reply-button:hover {
        background: rgba(89, 194, 255, 0.20);
      }
    '';
  };
}
