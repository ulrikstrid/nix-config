{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.home-assistant = {
    enable = true;

    extraComponents = [
      "default_config"
      "esphome"
      "met"

      # Extras
      "cloudflare"
      "husqvarna_automower"
      "local_calendar"
      "mobile_app"
      "mqtt"
      "rest"
      "smartthings"
      "sun"
      "unifi"
      "yale"
      "zwave_js"
      "utility_meter"
      "cast"
    ];

    customComponents = with pkgs.home-assistant-custom-components; [
      xiaomi_miot
    ];

    customLovelaceModules = with pkgs.home-assistant-custom-lovelace-modules; [
      bubble-card
    ];

    config = {
      tts = [ { platform = "google_translate"; } ];

      homeassistant = {
        name = "Home";
        latitude = "57.988434";
        longitude = "12.692189";
        country = "SE";
        unit_system = "metric";
        temperature_unit = "C";
        time_zone = "Europe/Stockholm";
        internal_url = "http://192.168.1.101:8123";
        external_url = "https://homeass.strid.ninja";
      };

      rest = import ./home-assistant/rest.nix;

      group = "!include groups.yaml";
      automation = "!include automations.yaml";
      script = "!include scripts.yaml";
      scene = "!include scenes.yaml";

      frontend = {
        themes = "!include_dir_merge_named themes";
      };

      http = {
        server_port = 8123;
        use_x_forwarded_for = true;
        trusted_proxies = "192.168.1.101";
      };

      default_config = { };
    };

    configDir = "/mnt/homeassistant";
  };

  environment.systemPackages = with pkgs; [ home-assistant-cli ];

  networking.firewall.allowedTCPPorts = [
    8123 # http
  ];

  age.secrets = with config; {
    home-assistant-google_assistant = {
      file = ../secrets/home_assistant_google_assistant.json.age;
      owner = systemd.services.home-assistant.serviceConfig.User;
      mode = "0440";
    };
    home-assistant-home_connect = {
      file = ../secrets/home_assistant_home_connect.yml.age;
      owner = systemd.services.home-assistant.serviceConfig.User;
      mode = "0440";
    };
  };
}
