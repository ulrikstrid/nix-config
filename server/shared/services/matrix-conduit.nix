{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.matrix-conduit = {
    enable = true;
    settings.global.allow_check_for_updates = true;
    settings.global.address = "0.0.0.0";
    settings.global.server_name = "m.strid.ninja";
    settings.global.port = 6167;
    settings.global.allow_registration = false;
    settings.global.database_backend = "rocksdb";
    settings.global.turn_uris = [
      "turn:turn.matrix.org?transport=udp"
      "turn:turn.matrix.org?transport=tcp"
    ];
    settings.global.turn_secret = "n0t4ctuAllymatr1Xd0TorgSshar3d5ecret4obvIousreAsons";
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "matrix_well-known" = {
        listen = [
          {
            addr = "0.0.0.0";
            port = 6168;
            ssl = false;
          }
        ];
        locations = {
          "= /.well-known/matrix/server".extraConfig = ''
            add_header Content-Type application/json;
            add_header Access-Control-Allow-Origin *;
            return 200 '{"m.server": "m.strid.ninja:443"}';
          '';
          "= /.well-known/matrix/client".extraConfig = ''
            add_header Content-Type application/json;
            add_header Access-Control-Allow-Origin *;
            return 200 '{"m.server": {"base_url": "https://m.strid.ninja"},"m.homeserver": {"base_url": "https://m.strid.ninja"}, "org.matrix.msc3575.proxy": {"url": "https://m.strid.ninja"}}';
          '';
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    6167
    6168
  ];
  networking.firewall.allowedUDPPorts = [
    6167
    6168
  ];
}
# , "m.identity_server": {"base_url": "https://matrix.org"}
