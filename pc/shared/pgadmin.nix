{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.pgadmin = {
    enable = true;
    initialEmail = "ulrik.strid@outlook.com";
    openFirewall = true;
    initialPasswordFile = config.age.secrets.pgadmin_password.path;
  };

  services.postgresql.package = pkgs.postgresql_13;

  age.secrets = with config; {
    pgadmin_password = {
      file = ../../server/shared/secrets/pgadmin_password.age;
      owner = systemd.services.pgadmin.serviceConfig.User;
      mode = "0440";
    };
  };
}
