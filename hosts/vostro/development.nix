{ pkgs, ... }:

{
  virtualisation.docker.enable = true;

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    ensureDatabases = [ "container-forms" "valid-users" ];
    ensureUsers = [
      { name = "declan"; }
    ];
  };
}
