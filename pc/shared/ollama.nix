{
  config,
  pkgs,
  lib,
  ...
}:

{
  services.ollama = {
    enable = false;
    # acceleration = "rocm";
    host = "0.0.0.0";
    port = 11434;
  };

  services.open-webui = {
    enable = config.services.ollama.enable;
    host = "0.0.0.0";
    openFirewall = true;
  };

  networking.firewall.allowedTCPPorts = [ 11434 ];
  networking.firewall.allowedUDPPorts = [ 11434 ];
}
