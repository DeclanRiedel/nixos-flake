{ lib, pkgs, ... }: {

  virtualisation = {
    #docker.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    #default /var/lib/postgresql/16

    ensureDatabases = [ "container-forms" "valid-users" ];
    ensureUsers = [{
      name = "declan";
    }
    #{
    #  name = "container-forms";
    #  ensureDBOwnership = true;
    #}
      ];
  };

}
