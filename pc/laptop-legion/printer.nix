# https://nixos.wiki/wiki/Printing
{ config
, pkgs
, lib
, ...
}: {
  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint pkgs.gutenprintBin ];
  };

  # IPP everywhere capable printer
  services.avahi = {
    enable = true;
    nssmdns = true;
    # for a WiFi printer
    openFirewall = true;
  };
}
