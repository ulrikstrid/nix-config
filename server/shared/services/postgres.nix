{ config, pkgs, lib, ... }:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_13;
    port = 5432;
    enableTCPIP = true;

    # Ensure the database, user, and permissions always exist
    ensureDatabases = [ "nextcloud" "hedgedoc" "vikunja" "tandoor" ];
    ensureUsers = [
      {
        name = "nextcloud";
        ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
      }
      {
        name = "hedgedoc";
        ensurePermissions."DATABASE hedgedoc" = "ALL PRIVILEGES";
      }
      {
        name = "vikunja";
        ensurePermissions."DATABASE vikunja" = "ALL PRIVILEGES";
      }
      {
        name = "tandoor";
        ensurePermissions."DATABASE tandoor" = "ALL PRIVILEGES";
      }
    ];

    authentication = lib.mkForce ''
      # Generated file; do not edit!
      # TYPE  DATABASE        USER            ADDRESS                 METHOD
      local   all             all                                     trust
      host    all             all             127.0.0.1/32            trust
      host    all             all             ::1/128                 trust
      host    all             all             192.168.1.0/24          trust
      host    all             all             172.17.0.0/24          trust
    '';
  };

  services.prometheus.exporters.postgres = {
    enable = true;
    port = 9187;
    openFirewall = true;
  };

  networking.firewall.allowedTCPPorts = [ 5432 ];
}
