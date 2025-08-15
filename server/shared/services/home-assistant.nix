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

      # Dependencies of xiaomi_miot
      "ffmpeg"
      "homekit"

      # Improve performance https://github.com/NixOS/nixpkgs/issues/330377
      "isal"

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
      "unifiprotect"
      "yale"
      "zwave_js"
      "utility_meter"
      "cast"
    ];

    customComponents = with pkgs.home-assistant-custom-components; [
      (xiaomi_miot.overrideAttrs (_old: {
        version = "1.0.20-dev";

        src = pkgs.fetchFromGitHub {
          owner = "al-one";
          repo = "hass-xiaomi-miot";
          # Fixes authentication issues with Xiaomi by adding captcha support
          # https://github.com/al-one/hass-xiaomi-miot/commit/aa99f3885405ede068dd117b5b2657184586ddcb
          rev = "aa99f3885405ede068dd117b5b2657184586ddcb";
          hash = "sha256-kifImeiytb7t+eyRCmHKPR+IkXkpsRKg0yikIQLX+40=";
        };
      }))
      alarmo
    ];

    customLovelaceModules = with pkgs.home-assistant-custom-lovelace-modules; [
      bubble-card
      vacuum-card
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

      logger = {
        default = "warning";
        logs = {
          "custom_components.xiaomi_miot" = "debug";
        };
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
