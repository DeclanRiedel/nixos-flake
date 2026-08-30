{
  fetchurl,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "codexbar";
  version = "0.56.0";

  src = fetchurl {
    url = "https://github.com/steipete/CodexBar/releases/download/v${finalAttrs.version}/CodexBarCLI-v${finalAttrs.version}-linux-musl-x86_64.tar.gz";
    hash = "sha256-hzCnAyiizm8ZDfE1ONEP6S2Pdnskclm+XdDBBhEYVqE=";
  };

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -Dm755 CodexBarCLI "$out/bin/codexbar"
    runHook postInstall
  '';

  meta = {
    description = "CLI for viewing AI coding subscription usage";
    homepage = "https://github.com/steipete/CodexBar";
    license = lib.licenses.mit;
    mainProgram = "codexbar";
    platforms = [ "x86_64-linux" ];
  };
})
