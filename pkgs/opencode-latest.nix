{ lib, pkgs }:

let
  version = "1.14.48";
in
pkgs.stdenvNoCC.mkDerivation {
  pname = "opencode";
  inherit version;

  src = pkgs.fetchurl {
    url = "https://github.com/anomalyco/opencode/releases/download/v${version}/opencode-linux-x64.tar.gz";
    hash = "sha256-0GEl3gdK+cF75kkTfivvWbd0x2aBMLAIb5vZm6Z7r4I=";
  };

  baselineSrc = pkgs.fetchurl {
    url = "https://github.com/anomalyco/opencode/releases/download/v${version}/opencode-linux-x64-baseline.tar.gz";
    hash = "sha256-14l6eBTGUryTmsVrNRg/lot34zF4p6LX725k6vD3aOQ=";
  };

  dontUnpack = true;
  nativeBuildInputs = with pkgs; [ patchelf ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/opencode/linux-x64 $out/lib/opencode/linux-x64-baseline
    tar -xzf $src -C $out/lib/opencode/linux-x64
    tar -xzf $baselineSrc -C $out/lib/opencode/linux-x64-baseline
    patchelf --set-interpreter ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 $out/lib/opencode/linux-x64/opencode
    patchelf --set-interpreter ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 $out/lib/opencode/linux-x64-baseline/opencode

    cat > $out/bin/opencode <<'EOF'
    #!${pkgs.runtimeShell}
    export PATH=${lib.makeBinPath [ pkgs.ripgrep ]}:$PATH
    if grep -qw avx2 /proc/cpuinfo 2>/dev/null; then
      exec @out@/lib/opencode/linux-x64/opencode "$@"
    fi
    exec @out@/lib/opencode/linux-x64-baseline/opencode "$@"
    EOF
    substituteInPlace $out/bin/opencode --replace-fail @out@ $out
    chmod +x $out/bin/opencode

    runHook postInstall
  '';

  meta = with lib; {
    description = "AI coding agent built for the terminal";
    homepage = "https://opencode.ai";
    license = licenses.mit;
    mainProgram = "opencode";
    platforms = [ "x86_64-linux" ];
  };
}
