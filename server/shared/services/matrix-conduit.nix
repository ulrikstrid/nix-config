{ config
, pkgs
, lib
, ...
}: {
  services.matrix-conduit = {
    enable = true;
    settings.global.allow_check_for_updates = true;
    settings.global.server_name = "m.strid.ninja";
    settings.global.allow_registration = true;
  };
}
