{ pkgs, ... }: {

 ## thunar

 programs.thunar.enable = true;
 programs.xfconf.enable = true;
 services.tumbler.enable = true;
 services.gvfs.enable = true;

environment.systemPackages = with pkgs; [
  vscode-fhs
  floorp
    #discord
  discord-screenaudio
  #xwaylandvideobridge #if discord-screenaudio not work 
  obsidian
  lorien
  texliveFull
];
}



  

