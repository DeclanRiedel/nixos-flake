{ pkgs, ... }:

{
  # Headless Spotify Connect daemon. With zeroconf discovery enabled and no
  # stored credentials the daemon shows up as a Spotify Connect device on the
  # local network — pick "vostro" from the Spotify app on any device and audio
  # streams here without the desktop client running. Playback is controlled
  # via MPRIS, which is what the Waybar spotify buttons drive through
  # `playerctl -p spotify,spotifyd`.
  services.spotifyd = {
    enable = true;
    package = pkgs.spotifyd.override { withMpris = true; withPulseAudio = true; };
    settings.global = {
      device_name = "vostro";
      backend = "pulseaudio";
      bitrate = 320;
      audio_format = "S16";
      zeroconf_port = 0;
    };
  };
}
