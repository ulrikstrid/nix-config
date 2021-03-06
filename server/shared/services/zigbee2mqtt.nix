{ config, pkgs, lib, ... }: {
  services.zigbee2mqtt = {
    enable = true;
    settings = {
      homeassistant = true;
      permit_join = true;

      mqtt = {
        server = "mqtt://192.168.1.101:1883";
        user = "zigbee2mqtt";
        password = "insecure-password";
      };

      serial = {
        port = "/dev/ttyACM0";
        adapter = "deconz";
      };

      frontend = {
        # Optional, default 8080
        port = 4080;
        # Optional, default 0.0.0.0
        host = "0.0.0.0";
      };

      advanced = { log_level = "debug"; };
    };
  };

  networking.firewall.allowedTCPPorts = [ 4080 1883 ];

  networking.firewall.allowedUDPPorts = [ 1883 ];
}
