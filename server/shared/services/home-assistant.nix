{
  config,
  pkgs,
  lib,
  ...
}: {
  services.home-assistant = {
    package =
      (pkgs.home-assistant.override {
        extraComponents = ["default_config" "esphome"];

        extraPackages = py: [
          pkgs.openzwave
          py.adguardhome
          py.aioesphomeapi
          py.aiohttp-cors
          py.aiohttp-cors
          py.aiohue
          py.aiounifi
          py.async-upnp-client
          py.bellows
          py.distro
          py.emoji
          py.gtts
          py.guppy3
          py.ha-ffmpeg
          py.hass-nabucasa
          py.hole
          py.homeconnect
          py.ical
          py.krakenex
          py.micloud
          py.mutagen
          py.netdisco
          py.objgraph
          py.paho-mqtt
          py.plexapi
          py.plexwebsocket
          py.pycfdns
          py.PyChromecast
          py.pycrypto
          py.pyipp
          py.pykrakenapi
          py.pynacl
          py.pyowm
          py.pyprof2calltree
          py.pysmartapp
          py.pysmartthings
          py.python_openzwave
          py.python-miio
          py.python-openzwave-mqtt
          py.pyunifiprotect
          py.pyxiaomigateway
          py.scapy
          py.securetar
          py.smhi-pkg
          py.spotipy
          py.sqlalchemy
          py.unifi-discovery
          py.zeroconf
          py.zha-quirks
          py.zigpy
          py.zigpy-cc
          py.zigpy-deconz
          py.zigpy-xbee
          py.zigpy-zigate
          py.zigpy-znp
          py.zwave-js-server-python
        ];
      })
      .overrideAttrs (_: {
        tests = [];
        doInstallCheck = false;
      });

    enable = true;

    config = {
      tts = [{platform = "google_translate";}];

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

      group = "!include groups.yaml";
      automation = "!include automations.yaml";
      script = "!include scripts.yaml";
      scene = "!include scenes.yaml";

      # home_connect = "!include ${config.age.secrets.home-assistant-home_connect.path}";
      # spotify = "!include ${config.age.secrets.home-assistant-spotify.path}";
      # nest = "!include ${config.age.secrets.home-assistant-nest.path}";
      #vacuum = "!include ${config.age.secrets.home-assistant-vacuum.path}";

      google_assistant = {
        project_id = "home-assistant-d8169";
        service_account = "!include ${config.age.secrets.home-assistant-google_assistant.path}";
        report_state = true;
        exposed_domains = ["light" "climate" "vacuum"];
        entity_config = {
          "switch.lampor_baksida" = {};
          "switch.lampor_framsida" = {name = "Lampor framsida hus";};
          "switch.lampor_framsida_2" = {name = "Lampa framsida stolpe";};
          "switch.window_lamp" = {name = "Fönsterlampa";};
        };
      };

      frontend = {themes = "!include_dir_merge_named themes";};

      http = {
        server_port = 8123;
        use_x_forwarded_for = true;
        trusted_proxies = "192.168.1.101";
      };

      default_config = {};
    };

    configDir = "/mnt/homeassistant";
  };

  environment.systemPackages = with pkgs; [home-assistant-cli];

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
    home-assistant-nest = {
      file = ../secrets/home_assistant_nest.yml.age;
      owner = systemd.services.home-assistant.serviceConfig.User;
      mode = "0440";
    };
    home-assistant-spotify = {
      file = ../secrets/home_assistant_spotify.yml.age;
      owner = systemd.services.home-assistant.serviceConfig.User;
      mode = "0440";
    };
    home-assistant-vacuum = {
      file = ../secrets/home_assistant_vacuum.yml.age;
      owner = systemd.services.home-assistant.serviceConfig.User;
      mode = "0440";
    };
  };
}
