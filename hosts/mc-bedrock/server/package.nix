{ autoPatchelfHook, curl, fetchurl, gcc, lib, openssl, stdenv, unzip, zlib }:

stdenv.mkDerivation rec {
  pname = "minecraft-bedrock-server";
  version = "1.26.20.5";

  src = fetchurl {
    url = "https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-${version}.zip";
    hash = "sha256-PK1HeM6EiFcSgmnPxK1XvWQXvuzm2FfsDfeYF00B4EA=";
    curlOptsList = [ "-L" "-H" "User-Agent: Mozilla/5.0" ];
  };

  nativeBuildInputs = [ autoPatchelfHook unzip ];
  buildInputs = [ curl openssl zlib gcc.cc.lib ];

  unpackCmd = "unzip $curSrc";
  sourceRoot = ".";
  installPhase = ''
    mkdir -p $out/lib/bedrock-server $out/bin
    cp -r * $out/lib/bedrock-server/
    cat > $out/bin/bedrock-server <<'SCRIPT'
    #!/bin/sh
    exec ${placeholder "out"}/lib/bedrock-server/bedrock_server "$@"
    SCRIPT
    chmod +x $out/bin/bedrock-server $out/lib/bedrock-server/bedrock_server
  '';

  meta = {
    description = "Minecraft Bedrock Dedicated Server";
    homepage = "https://www.minecraft.net/en-us/download/server/bedrock";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
