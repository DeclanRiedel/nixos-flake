{ config, ... }:

{
  sops = {
    defaultSopsFile = ../../secrets/default.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets = {
      "declan-password".neededForUsers = true;
      "root-password".neededForUsers = true;
    };
  };

  users.users = {
    declan.hashedPasswordFile = config.sops.secrets."declan-password".path;
    root.hashedPasswordFile = config.sops.secrets."root-password".path;
  };
}
