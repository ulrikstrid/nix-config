{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.prometheus = {
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 9002 ];
}
