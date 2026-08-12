{ config, hostConfig, ... }:

let
  passwordSecret = "${hostConfig.user.name}-password";
in
{
  sops = {
    defaultSopsFile = ../../secrets/default.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets = {
      ${passwordSecret}.neededForUsers = true;
      "root-password".neededForUsers = true;
      "wireguard-private-key" = {
        sopsFile = ../../secrets/wireguard.yaml;
      };
    };
  };

  users.users = {
    ${hostConfig.user.name}.hashedPasswordFile = config.sops.secrets.${passwordSecret}.path;
    root.hashedPasswordFile = config.sops.secrets."root-password".path;
  };
}
