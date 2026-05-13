{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    mpv
    spotify
    spotify-player
    spotify-cli-linux
    vlc
    ffmpeg
    atomicparsley
  ];
}
