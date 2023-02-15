{ config
, pkgs
, options
, ...
}: {
  sound.enable = true;

  hardware.pulseaudio.enable = true;

  services.pipewire.enable = false;
}
