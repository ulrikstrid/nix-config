
{ pkgs
, lib
, ...
}:

{
  programs.waybar = {
    enable = true;
  };

  programs.wofi = {
    enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = false;

    settings = {
      "$mod" = "SUPER";

      exec-once = [
        "waybar"
      ];
    
      bind = [
        "$mod, F, exec, firefox"
        "$mod, k, exec, kitty"

      ];

      bindm = [
        # mouse movements
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];

      input = {
        kb_layout = "se";
      };
    };
  };
}
