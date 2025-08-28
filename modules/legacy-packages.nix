{ pkgs, ... }: { environment.systemPackages = with pkgs; [ vim htop gnugrep ]; }
