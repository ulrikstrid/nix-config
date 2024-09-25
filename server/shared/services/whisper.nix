{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.wyoming.faster-whisper.servers = {
    homeass = {
      enable = true;
      device = "cpu";
      language = "sv";
      uri = "tcp://0.0.0.0:10300";
    };
  };
}
