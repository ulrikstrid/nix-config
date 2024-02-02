{pkgs, ...}: {
  programs.adb.enable = true;
  users.users.ulrik.extraGroups = ["adbusers"];
}
