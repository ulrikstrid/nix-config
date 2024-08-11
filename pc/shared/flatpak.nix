{ lib, config, ... }:
{
  services.flatpak.enable = true;

  xdg.portal.enable = lib.mkForce true;
}
