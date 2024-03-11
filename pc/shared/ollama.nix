{
  config,
  pkgs,
  lib,
  acceleration ? "rocm",
  ...
}:
  let port = 11434;
  in
{
  services.ollama = {
    inherit acceleration;
    enable = true;
    listenAddress = "0.0.0.0:${port}";
  };

  networking.firewall.allowedTCPPorts = [ port ];
  networking.firewall.allowedUDPPorts = [ port ];
}
