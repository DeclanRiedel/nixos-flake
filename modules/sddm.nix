{ lib, pkgs, ... }:

let
  themeName = "sddm-spiderverse";
  wallpaper = ../wall/sddm-wall.jpg;

  # The hyprland package ships both hyprland.desktop and hyprland-uwsm.desktop;
  # the SDDM greeter sorts hyprland-uwsm.desktop first and launches it, but the
  # uwsm session exits 127 and dumps the user back at the greeter. Register a
  # session package that exposes only the working direct hyprland.desktop entry.
  hyprlandSessionOnly = pkgs.runCommand "hyprland-session-only"
    {
      passthru.providedSessions = [ "hyprland" ];
    } ''
    mkdir -p "$out/share/wayland-sessions"
    cp ${pkgs.hyprland}/share/wayland-sessions/hyprland.desktop "$out/share/wayland-sessions/"
  '';

  spiderverseTheme = pkgs.sddm-astronaut.overrideAttrs (_: {
    pname = themeName;
    name = themeName;

    installPhase = ''
      runHook preInstall

      themeDir="$out/share/sddm/themes/${themeName}"
      mkdir -p "$themeDir"
      cp -r "$src"/* "$themeDir"
      chmod -R u+w "$themeDir"

      install -Dm0644 ${wallpaper} "$themeDir/Backgrounds/spiderverse.jpg"

      cat > "$themeDir/Themes/spiderverse.conf" <<'EOF'
      [General]
      ScreenWidth="1920"
      ScreenHeight="1080"
      ScreenPadding="0"

      Font="KogniGear"
      FontSize="12"
      KeyboardSize="0.4"
      RoundCorners="8"

      Locale=""
      HourFormat="HH:mm"
      DateFormat="dddd, MMMM d"
      HeaderText="Welcome back"

      BackgroundPlaceholder=""
      Background="Backgrounds/spiderverse.jpg"
      BackgroundSpeed=""
      PauseBackground=""
      DimBackground="0.18"
      CropBackground="true"
      BackgroundHorizontalAlignment="center"
      BackgroundVerticalAlignment="center"

      HeaderTextColor="#F5E85B"
      DateTextColor="#F9D956"
      TimeTextColor="#5BE7FF"

      FormBackgroundColor="#070A10"
      BackgroundColor="#070A10"
      DimBackgroundColor="#03050A"

      LoginFieldBackgroundColor="#111927"
      PasswordFieldBackgroundColor="#111927"
      LoginFieldTextColor="#F7FAFF"
      PasswordFieldTextColor="#F7FAFF"
      UserIconColor="#5BE7FF"
      PasswordIconColor="#5BE7FF"

      PlaceholderTextColor="#9CA8B8"
      WarningColor="#FF4D5A"

      LoginButtonTextColor="#070A10"
      LoginButtonBackgroundColor="#F5E85B"
      SystemButtonsIconsColor="#5BE7FF"
      SessionButtonTextColor="#5BE7FF"
      VirtualKeyboardButtonTextColor="#5BE7FF"

      DropdownTextColor="#F7FAFF"
      DropdownSelectedBackgroundColor="#C92A3A"
      DropdownBackgroundColor="#111927"

      HighlightTextColor="#070A10"
      HighlightBackgroundColor="#F5E85B"
      HighlightBorderColor="#5BE7FF"

      HoverUserIconColor="#F5E85B"
      HoverPasswordIconColor="#F5E85B"
      HoverSystemButtonsIconsColor="#F5E85B"
      HoverSessionButtonTextColor="#F5E85B"
      HoverVirtualKeyboardButtonTextColor="#F5E85B"

      PartialBlur="true"
      FullBlur="false"
      BlurMax="18"
      Blur="0.85"
      HaveFormBackground="true"
      FormPosition="right"

      VirtualKeyboardPosition="right"

      HideVirtualKeyboard="true"
      HideSystemButtons="false"
      HideLoginButton="false"

      ForceLastUser="true"
      PasswordFocus="true"
      HideCompletePassword="true"
      AllowEmptyPassword="false"
      AllowUppercaseLettersInUsernames="true"
      BypassSystemButtonsChecks="false"
      RightToLeftLayout="false"

      TranslatePlaceholderUsername=""
      TranslatePlaceholderPassword=""
      TranslateLogin=""
      TranslateLoginFailedWarning=""
      TranslateCapslockWarning=""
      TranslateSuspend=""
      TranslateHibernate=""
      TranslateReboot=""
      TranslateShutdown=""
      TranslateSessionSelection=""
      TranslateVirtualKeyboardButtonOn=""
      TranslateVirtualKeyboardButtonOff=""
      EOF

      substituteInPlace "$themeDir/metadata.desktop" \
        --replace-fail "Name=sddm-astronaut-theme" "Name=${themeName}" \
        --replace-fail "Description=sddm-astronaut-theme" "Description=Spider-Verse SDDM theme" \
        --replace-fail "ConfigFile=Themes/astronaut.conf" "ConfigFile=Themes/spiderverse.conf" \
        --replace-fail "Screenshot=Previews/astronaut.png" "Screenshot=Backgrounds/spiderverse.jpg" \
        --replace-fail "Theme-Id=sddm-astronaut-theme" "Theme-Id=${themeName}"

      runHook postInstall
    '';
  });
in
{
  environment.systemPackages = [
    pkgs.bibata-cursors
    spiderverseTheme
  ];

  services.displayManager = {
    # The uwsm-managed entry exits immediately under SDDM on this host, sending
    # the user back to the greeter. Use Hyprland's direct session entry, which
    # runs the same start-hyprland launcher that works from a TTY.
    defaultSession = lib.mkForce "hyprland";

    # Drop the broken hyprland-uwsm.desktop entry; offer only the direct session.
    sessionPackages = lib.mkForce [ hyprlandSessionOnly ];

    sddm = {
      enable = true;
      extraPackages = [ spiderverseTheme ];
      theme = lib.mkForce themeName;
      wayland.enable = false;

      settings = {
        General = {
          DisplayServer = "x11";
          InputMethod = "qtvirtualkeyboard";
        };

        Theme = {
          Current = themeName;
          CursorTheme = "Bibata-Modern-Ice";
          CursorSize = 24;
        };

        Users = {
          RememberLastSession = false;
          RememberLastUser = true;
        };
      };
    };
  };

  system.activationScripts.sddm-avatar.text = ''
    install -d -m 0755 /var/lib/AccountsService/icons
    install -d -m 0755 /var/lib/AccountsService/users

    for user in /home/*; do
      username=$(basename "$user")
      icon_source="$user/.face.icon"
      icon_dest="/var/lib/AccountsService/icons/$username"
      user_dest="/var/lib/AccountsService/users/$username"

      if [ -f "$icon_source" ]; then
        if [ ! -f "$icon_dest" ] || ! cmp -s "$icon_source" "$icon_dest"; then
          rm -f "$icon_dest"
          cp -L "$icon_source" "$icon_dest"
          chmod 0644 "$icon_dest"
        fi

        printf '[User]\nIcon=%s\n' "$icon_dest" > "$user_dest"
        chmod 0644 "$user_dest"
      fi
    done
  '';

  systemd.tmpfiles.rules = [
    "d /var/lib/AccountsService/icons 0755 root root -"
    "d /var/lib/AccountsService/users 0755 root root -"
  ];

  systemd.services.sddm = {
    after = [ "systemd-tmpfiles-setup.service" ];
  };
}
