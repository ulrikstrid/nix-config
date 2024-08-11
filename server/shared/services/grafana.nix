{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.grafana = {
    enable = true;
    # domain = "grafana.pele";
    settings.server = {
      http_port = 8342;
      http_addr = "0.0.0.0";
    };

    declarativePlugins = with pkgs.grafanaPlugins; [ grafana-piechart-panel ];
  };

  networking.firewall.allowedTCPPorts = [ 8342 ];
}
