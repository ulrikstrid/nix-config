{ config, pkgs, lib, ... }:

{
  services.unifi-poller = {
    enable = true;

    prometheus = {
      disable = false;
      report_errors = true;
      http_listen = "0.0.0.0:9130";
    };

    influxdb.disable = true;

    unifi = {
      controllers = [{
        url = "http://192.168.1.1";

        user = "unifi-poller";
        pass = config.age.secrets.unifi-poller.path;

        sites = "all";
        save_ids = true;
        save_dpi = true;
        save_sites = true;
        # hash_pii = true;
      }];
    };
  };

  systemd.services.unifi-poller = {
    serviceConfig.SupplementaryGroups = [ config.users.groups.keys.name ];
  };

  age.secrets = with config; {
    unifi-poller = {
      file = ../secrets/unifi-poller.age;
      mode = "0440";
      owner = systemd.services.unifi-poller.serviceConfig.User;
    };
  };
}
