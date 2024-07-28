{
  ## music-player (server) set up or just mpv --shuffle * 
  services.mpd = {
    enable = true;
    user = "declan";
    startWhenNeeded = true;
    playlistDirectory = "/home/declan/Media/Music";
    #muiscDirectory = "/home/declan/Media/Music";
  };

}
