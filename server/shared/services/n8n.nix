{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.n8n = {
    enable = true;
    openFirewall = true;
    webhookUrl = "https://n8n.strid.ninja/";
    settings = {
      port = 5678;
      generic = {
        timezone = "Europe/Stockholm";
      };
    };
  };

  systemd.services.n8n.environment = {
    N8N_METRICS = "true";
    N8N_EDITOR_BASE_URL = "https://n8n.strid.ninja/";
    N8N_PROTOCOL = "https";
    N8N_HOST = "n8n.strid.ninja";
  };
}
