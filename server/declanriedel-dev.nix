{ config, pkgs, ... }:

{
  # Enable the Nginx service.
  services.nginx = {
    enable = true;
    virtualHosts."declanriedel.dev" = {
      enableACME =
        true; # Enables automatic Let's Encrypt certificate generation
      forceSSL = true;
      root =
        "/home/declan/.dotfiles/nixos-flake/server/src/portfolio/";
    };
  };

  # Make sure the firewall allows HTTP and HTTPS traffic.
  networking.firewall = { allowedTCPPorts = [ 80 443 ]; };

  # Set up the ACME (Let's Encrypt) client for automatic certificate renewal.
  security.acme = {
    acceptTerms = true;
    defaults.email = "declanriedel@protonmail.com";
  };
}
