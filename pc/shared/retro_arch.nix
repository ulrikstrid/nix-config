{ config, pkgs, ... }:
let
  retroarch' = pkgs.retroarch.override {
    cores = with pkgs; [
      libretro.genesis-plus-gx
      libretro.snes9x
      libretro.beetle-psx-hw
      libretro.picodrive
    ];
  };
in
{
  services.xserver = {
    enable = true;
    desktopManager.retroarch = {
      enable = true;
      package = retroarch';
    };

    displayManager.defaultSession = "RetroArch";
    displayManager.sddm.enable = true;
    displayManager.autoLogin = {
      user = "ulrik.strid";
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    retroarch'
    libretro.genesis-plus-gx
    libretro.snes9x
    libretro.beetle-psx-hw
    libretro.picodrive
  ];
}
