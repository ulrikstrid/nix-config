{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.coturn = rec {
    enable = true;
    no-cli = true;
    no-tcp-relay = true;
    min-port = 49000;
    max-port = 50000;
    use-auth-secret = true;
    #static-auth-secret-file = config.age.secrets.coturn-secret.path;
    static-auth-secret = "static-auth-secret";
    realm = "turn.strid.ninja";
    cert = "${config.security.acme.certs.${realm}.directory}/full.pem";
    pkey = "${config.security.acme.certs.${realm}.directory}/key.pem";
    extraConfig = ''
      # for debugging
      verbose
      # VoIP traffic is all UDP. There is no reason to let users connect to arbitrary TCP endpoints via the relay.
      no-tcp-relay

      # don't let the relay ever try to connect to private IP address ranges within your network (if any)
      # given the turn server is likely behind your firewall, remember to include any privileged public IPs too.
      denied-peer-ip=10.0.0.0-10.255.255.255
      denied-peer-ip=192.168.0.0-192.168.255.255
      denied-peer-ip=172.16.0.0-172.31.255.255

      # recommended additional local peers to block, to mitigate external access to internal services.
      # https://www.rtcsec.com/article/slack-webrtc-turn-compromise-and-bug-bounty/#how-to-fix-an-open-turn-relay-to-address-this-vulnerability
      no-multicast-peers
      denied-peer-ip=0.0.0.0-0.255.255.255
      denied-peer-ip=100.64.0.0-100.127.255.255
      denied-peer-ip=127.0.0.0-127.255.255.255
      denied-peer-ip=169.254.0.0-169.254.255.255
      denied-peer-ip=192.0.0.0-192.0.0.255
      denied-peer-ip=192.0.2.0-192.0.2.255
      denied-peer-ip=192.88.99.0-192.88.99.255
      denied-peer-ip=198.18.0.0-198.19.255.255
      denied-peer-ip=198.51.100.0-198.51.100.255
      denied-peer-ip=203.0.113.0-203.0.113.255
      denied-peer-ip=240.0.0.0-255.255.255.255
    '';
  };
  # open the firewall
  networking.firewall =
    let
      range = with config.services.coturn; [
        {
          from = min-port;
          to = max-port;
        }
      ];
    in
    {
      allowedUDPPortRanges = range;
      allowedUDPPorts = [
        3478
        5349
      ];
      allowedTCPPortRanges = [ ];
      allowedTCPPorts = [
        3478
        5349
      ];
    };

  # get a certificate
  security.acme.certs.${config.services.coturn.realm} = {
    dnsProvider = "cloudflare";
    credentialsFile = config.age.secrets.acme-credentials.path;
    # insert here the right configuration to obtain a certificate
    postRun = "systemctl restart coturn.service";
    group = "turnserver";
  };

  # configure conduit to point users to coturn
  services.matrix-conduit.settings.global = with config.services.coturn; {
    turn_uris = [
      "turn:${realm}:3478?transport=udp"
      "turn:${realm}:3478?transport=tcp"
    ];
    turn_secret = "static-auth-secret";
  };

  age.secrets = with config; {
    coturn-secret = {
      file = ../secrets/coturn-secret.age;
      owner = systemd.services.coturn.serviceConfig.User;
      mode = "0440";
    };
    acme-credentials = {
      file = ../secrets/traefik-env.age;
      owner = systemd.services.coturn.serviceConfig.User;
      group = "turnserver";
      mode = "0440";
    };
  };
}
