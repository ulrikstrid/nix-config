{
  config,
  pkgs,
  lib,
  ...
}:
let
  nextcloud_host = "nextcloud.strid.ninja";
in
{
  /*
    services.nginx = {
    enable = true;

    # Use recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    # Only allow PFS-enabled ciphers with AES256
    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

    # Setup Nextcloud virtual host to listen on ports
    virtualHosts = {
    ${nextcloud_host} = {
    ## Force HTTP redirect to HTTPS
    forceSSL = true;
    ## LetsEncrypt
    enableACME = true;
    };
    };
    };
  */

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud23;
    hostName = nextcloud_host;
    datadir = "/nas/server/nextcloud";

    # Enable built-in virtual host management
    # Takes care of somewhat complicated setup
    # See here: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/web-apps/nextcloud.nix#L529
    # nginx.enable = true;

    # Use HTTPS for links
    https = true;

    # Auto-update Nextcloud Apps
    autoUpdateApps.enable = true;
    # Set what time makes sense for you
    autoUpdateApps.startAt = "05:00:00";

    config = {
      # Further forces Nextcloud to use HTTPS
      overwriteProtocol = "https";

      # Nextcloud PostegreSQL database configuration, recommended over using SQLite
      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbhost = "192.168.1.101"; # nextcloud will add /.s.PGSQL.5432 by itself
      dbport = 5432;
      dbname = "nextcloud";
      #dbpass = "nextcloud";
      dbpassFile = "/var/nextcloud-db-pass";

      adminpassFile = "/var/nextcloud-admin-pass";
      adminuser = "admin";
      #adminpass = "admin";

      defaultPhoneRegion = "SE";

      trustedProxies = [ "nextcloud.strid.ninja" ];
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  security.acme = {
    acceptTerms = true;
    email = "ulrik.strid@outlook.com";
  };
}
