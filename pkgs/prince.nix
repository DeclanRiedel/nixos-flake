{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, makeWrapper
, fontconfig
}:

stdenv.mkDerivation rec {
  pname = "prince";
  version = "16.2";

  src = fetchurl {
    url = "https://www.princexml.com/download/prince-${version}-linux-generic-x86_64.tar.gz";
    sha256 = "1g4b1bjghj294x0cl4dwzr5x1csnc42wd4c2xynk5s3yn3hfq7hk";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    fontconfig
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/lib"
    cp -R lib/prince "$out/lib/prince"

    makeWrapper "$out/lib/prince/bin/prince" "$out/bin/prince" \
      --add-flags "--prefix=$out/lib/prince"

    runHook postInstall
  '';

  meta = {
    description = "Formatter for converting HTML and XML into PDF";
    homepage = "https://www.princexml.com";
    license = lib.licenses.unfree;
    mainProgram = "prince";
    platforms = [ "x86_64-linux" ];
  };
}
