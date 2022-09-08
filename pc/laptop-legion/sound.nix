{ config, pkgs, options, ... }:

{
  sound.enable = true;

  # High quality BT calls
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull;
    hsphfpd.enable = true;
  };

  # Pipewire config
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    # No idea if I need this
    alsa.support32Bit = true;
    pulse.enable = true;

    wireplumber.enable = true;
  };

  environment.etc = {
    "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
      bluez_monitor.properties = {
        ["bluez5.enable-sbc-xq"] = true,
        ["bluez5.enable-msbc"] = true,
        ["bluez5.enable-hw-volume"] = true,
        ["bluez5.codecs"] = "[sbc sbc_xq]",
        ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
      }
    '';
  };
}
