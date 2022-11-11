{pkgs, ...}: {
  programs.gnome-terminal = {
    enable = true;
    showMenubar = true;
    themeVariant = "system";

    profile = {
      "default" = {
        default = true;
        visibleName = false;
      };
      "servern-ssh" = {
        customCommand = "ssh ulrik.strid@192.168.1.101";
        visibleName = true;
      };
    };
  };
}
