# From: https://gist.github.com/jsimonetti/c636b948fb1a4fe43a90805c64a0b99e
{ config
, pkgs
, lib
, ...
}: {
  # services.haveged.enable = true;

  virtualisation.oci-containers.containers = {
    zwave2mqtt = {
      image = "zwavejs/zwave-js-ui:9.2.3";
      user = "root";
      environment = { TZ = "Europe/Stockholm"; };
      ports = [ "8091:8091" "3300:3000" ];
      volumes = [ "/data/persist/zwavejs:/usr/src/app/store" ];
      extraOptions = [
        "--privileged"
        "--tty"
        "--device=/dev/serial/by-id/usb-0658_0200-if00:/dev/zwave"
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [
    3300 # ws
    8091 # http
  ];

  networking.firewall.allowedUDPPorts = [
    3300 # ws
    8091 # http
  ];

  #systemd.services.docker-zwave2mqtt.serviceConfig = {
  #  StandardOutput = lib.mkForce "journal";
  #  StandardError = lib.mkForce "journal";
  #};
}
