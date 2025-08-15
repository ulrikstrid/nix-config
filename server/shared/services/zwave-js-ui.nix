{
  ...
}:

{
  services.zwave-js-ui = {
    enable = true;
    serialPort = "/dev/serial/by-id/usb-0658_0200-if00";
    settings = {
      PORT = "8091";
      TZ = "Europe/Stockholm";
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
}
