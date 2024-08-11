{
  config,
  pkgs,
  lib,
  ...
}:
let
  port = "11434";
in
{
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    listenAddress = "0.0.0.0:${port}";
  };

  networking.firewall.allowedTCPPorts = [ 11434 ];
  networking.firewall.allowedUDPPorts = [ 11434 ];
}
