{
  config,
  pkgs,
  lib,
  ...
}: {
  services.mosquitto = {
    enable = true;

    listeners = [
      {
        address = "0.0.0.0";
        port = 1883;
        users = {
          home-assistant = {
            passwordFile = config.age.secrets.mosquitto-home-assistant.path;
            acl = ["readwrite #"];
          };
          zigbee2mqtt = {
            # TODO: Use this
            # passwordFile = config.age.secrets.mosquitto-zigbee2mqtt.path;
            password = "insecure-password";
            acl = ["readwrite #"];
          };
        };
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [1883];

  age.secrets = with config; {
    mosquitto-home-assistant = {
      file = ../secrets/mosquitto-home-assistant.age;
      owner = systemd.services.mosquitto.serviceConfig.User;
      mode = "0440";
    };

    mosquitto-zigbee2mqtt = {
      file = ../secrets/mosquitto-zigbee2mqtt.age;
      owner = systemd.services.mosquitto.serviceConfig.User;
      mode = "0440";
    };
  };
}
