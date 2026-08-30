{ appimageTools
, fetchurl
, lib
, makeDesktopItem
,
}:

let
  pname = "t3code-nightly";
  version = "0.0.37-nightly.20260830.1227";
  src = fetchurl {
    url = "https://github.com/pingdotgg/t3code/releases/download/v${version}/T3-Code-${version}-x86_64.AppImage";
    hash = "sha256-NMyljgXgsIN9Xt8e2eunaLBakM1H4J7iSzclmyezacs=";
  };
  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
  desktopItem = makeDesktopItem {
    name = "t3code-nightly";
    desktopName = "T3 Code (Nightly)";
    comment = "Nightly desktop control surface for local coding agents";
    exec = "t3code-nightly %U";
    terminal = false;
    icon = "t3code";
    startupWMClass = "t3code";
    categories = [ "Development" ];
    mimeTypes = [ "x-scheme-handler/t3code" ];
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 \
      ${desktopItem}/share/applications/t3code-nightly.desktop \
      $out/share/applications/t3code-nightly.desktop
    if [ -d ${appimageContents}/usr/share/icons ]; then
      cp -r ${appimageContents}/usr/share/icons $out/share/
    fi
  '';

  meta = {
    description = "Nightly desktop control surface for local coding agents";
    homepage = "https://t3.codes";
    downloadPage = "https://github.com/pingdotgg/t3code/releases";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
