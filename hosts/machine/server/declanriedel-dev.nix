{ hostConfig, ... }:

{
  services.nginx = {
    enable = true;
    virtualHosts."declanriedel.dev" = {
      enableACME = true;
      forceSSL = true;
      root = "${hostConfig.user.home}/.nixos/hosts/machine/server/src/portfolio";
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "declanriedel@protonmail.com";
  };
}
