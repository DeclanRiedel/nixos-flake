{
  home.file = {
    ".config/waybar/config".text = ''
                        {
                            // Choose the order of the modulesaround
                            "modules-left": ["hyprland/workspaces"],
                            "modules-center": ["mpris", "custom/spacer", "hyprland/window"],
                            "modules-right": ["tray", "clock","idle_inhibitor", "custom/pacman","network", "backlight", "pulseaudio", "battery" ],

                             "hyprland/workspaces": {
                                 "disable-scroll": true,
                                 "all-outputs": true,
                                 "warp-on-scroll": false,
                        	 "format": " {icon} ",
                                 "format-icons": {
                        	     "1": "1",
                        	     "2": "2",
                        	     "3": "3",
                        	     "4": "4",
                        	     "5": "5",
                        	     "6": "6",
                        	     "7": "7",
                        	     "8": "8",
                        	     "9": "9"
                                 }
                             },

                             "hyprland/window": {
                               "max-length": 45,
                             },
                            "keyboard-state": {
                                "numlock": true,
                                "capslock": true,
                                "format": "{name} {icon}",
                                "format-icons": {
                                    "locked": "",
                                    "unlocked": ""
                                }
                            },

                            "tray": {
                                "spacing": 6 
                            },

                            "mpris": {
            	"format": "{status_icon} {title}",
            	"format-paused": "{status_icon} {title}",
            	"player-icons": {
            		"default": "▶",
            		"mpv": "🎵"
            	},
            	"status-icons": {
            		"paused": "⏸"
            	},
              "max-length": 35
            },

                            "custom/pacman": {
                                "format": "{icon} {}",
                                "return-type": "json",
                                "format-icons": {
                                  "pending-updates": " ",
                                  "updated": ""
                                },
                                "exec-if": "which waybar-updates",
                                "exec": "waybar-updates"
                            },

                            "clock": {
                                // "timezone": "Africa/Windhoek",
                                "tooltip-format": "<tt><small>{calendar}</small></tt>",
                                "format-alt": "{:%m-%d-%Y}",
                        	"format": "{:%I:%M %p}"
                            },

      "custom/spacer": { 
      "format": " "
      },
                            "idle_inhibitor": {
                      "format": "{icon}",
                      "format-icons": {
                          "activated": "",
                          "deactivated": ""
                      }
                  },
                            "hyprland/language": {
                            	"format": "󰌌  {}",
                            	"format-en": "en",
                        	"format-fr": "fr",
                        	"format-it": "it"
                            },

                            "backlight": {
                                // "device": "acpi_video1",
                                "format": "{icon} {percent}%",
                                "format-icons": ["", "", "", "", "", "", "", "", ""]
                            },



                          "network": {
                            "format-wifi": "  {essid}",
                            "format-ethernet": "󰈀 Connected",
                            "format-linked": "󰜏 {ifname} (No IP)",
                            "format-disconnected": "Disconnected",
                            "format-alt": "󰜏 {ifname}: {ipaddr}/{cidr}"
                            },

                            "battery": {
                                "states": {
                                    "warning": 15,
                                },
                                "format": "{icon} {capacity}%",
                                "format-charging": "󰂄 {capacity}%",
                        	"format-warning": "󰂃 {capacity}%",
                                "format-alt": "{icon} {time}",
                                "format-icons": ["󰁺", "󰁻", "󰁽", "󰁽", "󰁿", "󰂁", "󰁹"]
                            },

                            "pulseaudio": {
                            "format": "{icon}  {volume}%",
                            "format-muted": "󰖁 muted",
                            "format-icons": {
                              "headphone": "",
                              "hands-free": "",
                              "headset": "󰋎",
                              "phone": "",
                              "portable": "",
                              "car": "",
                              "default": ["", "", ""]
                            },
                            "on-click": "pamixer --toggle-mute",
                            "on-click-right": "pavucontrol"
                          },

                            "custom/media": {
                                "format": "{icon} {}",
                                "return-type": "json",
                                "max-length": 40,
                                "format-icons": {
                                    "spotify": " ",
                                    "default": "🎜 "
                                },
                                "escape": true,
                                "exec": "$HOME/.config/waybar/mediaplayer.py 2> /dev/null" // Script in resources folder
                                // "exec": "$HOME/.config/waybar/mediaplayer.py --player spotify 2> /dev/null" // Filter player based on name
                            }
                        }
    '';

    ".config/waybar/style.css".text = ''
          @import "mocha.css";
           * {
              font-family: Iosevka Nerd Font;
              font-weight: bold;
              font-size: 14px;
              min-height: 0;
              padding: 0;
              margin: 0;
              border-radius: 0;
            }


        window#waybar {
      background-color: rgba(30, 30, 46, 0);
      transition-property: background-color;
      transition-duration: 0.5s;
      }


            #workspaces {
              border-radius: 0.75rem;
              margin: 5px;
              background-color: rgba(36, 40, 59, 0.7);
              margin-left: 0.25rem;
            }

            #workspaces button {
              min-width: 2em;
              color: @text;
              border-radius: 0.75rem;
            }

            #workspaces button.active {
              background-color: @rosewater;
              margin: 2px 2px;
              color: @base;
            }

            #workspaces button.urgent {
              color: @red;
            }

            #window,
            #mpris,
            #tray,
            #language,
            #network,
            #custom-media,
            #backlight,
            #clock,
            #idle_inhibitor,
            #battery,
            #custom-pacman,
            #pulseaudio {
              background-color: rgba(36, 40, 59, 0.7);
              margin: 5px 0;
              padding: 0rem 0.75rem 0rem;
            }
            #backlight {
              color: @red;
            }

            #custom-media {
              background-color: rgba(158, 206, 106, 0.7);
              color: @base;
              border-radius: 1rem;
              margin-left: 4rem;
            }

            #window {
              color: @mauve;
              border-radius: 1rem;
            }

            #mpris {
            color: @mauve;
            border-radius: 1rem;
            }

            window#waybar.empty #window {
              background-color: transparent;
            }
            #language {
              color: @yellow;
            }

            #clock {
              color: @peach;
              border-radius: 1rem 0px 0px 1rem;
              margin-left: 1rem;
            }

            #custom-pacman {
              color: @teal;
            }

            #network {
              color: @teal;
            }

            #idle_inhibitor {
            color: @red;
            }

            #battery.warning:not(.charging) {
              color: @red;
            }

            #pulseaudio {
              color: @yellow;
            }

            #battery {
              color: @green;
              border-radius: 0px 1rem 1rem 0px;
              margin-right: 0.25rem;
            }

            #tray {
              border-radius: 1rem;
            }
    '';
    ".config/waybar/mocha.css".text = ''
      /*
      *
      * Tokyo Night Storm palette
      * Adapted from Catppuccin Latte
      *
      */
      @define-color base   #24283b; 
      @define-color mantle #1f2335;
      @define-color crust  #1a1b26;

      @define-color text     #a9b1d6;
      @define-color subtext0 #9aa5ce;
      @define-color subtext1 #565f89;
      @define-color surface0 #292e42;
      @define-color surface1 #414868;
      @define-color surface2 #545c7e;

      @define-color overlay0 #737aa2;
      @define-color overlay1 #7982a9;
      @define-color overlay2 #8389b2;

      @define-color blue      #7aa2f7;
      @define-color lavender  #bb9af7;
      @define-color sapphire  #7dcfff;
      @define-color sky       #7dcfff;
      @define-color teal      #2ac3de;
      @define-color green     #9ece6a;
      @define-color yellow    #e0af68;
      @define-color peach     #ff9e64;
      @define-color maroon    #db4b4b;
      @define-color red       #f7768e;
      @define-color mauve     #bb9af7;
      @define-color pink      #ff007c;
      @define-color flamingo  #ff9e64;
      @define-color rosewater #f7768e;'';
  };

}
