{
  config,
  pkgs,
  lib,
  ...
}:

{
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    host = "0.0.0.0";
    port = 11434;
    openFirewall = true;
  };

  services.open-webui = {
    enable = config.services.ollama.enable;
    host = "0.0.0.0";
    environment = {
      ANONYMIZED_TELEMETRY = "False";
      DO_NOT_TRACK = "True";
      SCARF_NO_ANALYTICS = "True";
      OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
    };
    openFirewall = true;
  };
}
