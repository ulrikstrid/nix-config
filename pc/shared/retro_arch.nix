{ config, pkgs, ... }:

let retroarch' =
  (pkgs.retroarch.override {
    cores = with pkgs; [
      libretro.genesis-plus-gx
      libretro.snes9x
      libretro.beetle-psx-hw
    ];
  });
in

{
  services.xserver = {
    enable = true;
    desktopManager.retroarch = {
      enable = true;
      package = retroarch';
    };

    displayManager.defaultSession = "RetroArch";
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
];
} 