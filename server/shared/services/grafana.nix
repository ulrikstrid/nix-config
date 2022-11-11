{
  config,
  pkgs,
  lib,
  ...
}: {
  services.grafana = {
    enable = true;
    # domain = "grafana.pele";
    port = 8342;
    addr = "0.0.0.0";

    declarativePlugins = with pkgs.grafanaPlugins; [grafana-piechart-panel];
  };

  networking.firewall.allowedTCPPorts = [8342];
}
