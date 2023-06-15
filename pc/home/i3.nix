{ config, lib, pkgs, ... }:

let
  mod = "Mod4";
in
{
  xsession.enable = true;

  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = {
      modifier = mod;

      gaps = {
        inner = 12;
        outer = 5;
        smartGaps = true;
        smartBorders = "off";
      };

      startup = [
        { command = "exec firefox"; }
        { command = "exec steam"; }
      ];

      assigns = {
        "2: web" = [{ class = "^Firefox$"; }];
        "4" = [{ class = "^Steam$"; }];
      };
    };
  };
}
