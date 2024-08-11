{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };

  services.printing = {
    enable = true;
    drivers = [
      pkgs.gutenprint
      pkgs.gutenprintBin
    ];
    browsing = true;
    listenAddresses = [ "*:631" ];
    allowFrom = [ "all" ];
    defaultShared = true;
  };

  networking.firewall = {
    allowedUDPPorts = [ 631 ];
    allowedTCPPorts = [ 631 ];
  };
}
