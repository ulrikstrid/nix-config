{
  config,
  pkgs,
  lib,
  ...
}: {
  services.traefik = {
    enable = true;
    staticConfigOptions = {
      api = {dashboard = true;};
      entryPoints = {
        http = {address = ":80";};

        https = {address = ":443";};

        traefik = {address = ":9090";};

        metrics = {address = ":8082";};
      };
      certificatesResolvers.cloudflare_staging.acme = {
        caServer = "https://acme-staging-v02.api.letsencrypt.org/directory";
        email = "ulrik.strid@outlook.com";
        storage = "/var/lib/traefik/acme.json";
        dnsChallenge = {
          provider = "cloudflare";
          delayBeforeCheck = 0;
        };
      };
      certificatesResolvers.cloudflare_prod.acme = {
        caServer = "https://acme-v02.api.letsencrypt.org/directory";
        email = "ulrik.strid@outlook.com";
        storage = "/var/lib/traefik/acme.json";
        dnsChallenge = {
          provider = "cloudflare";
          delayBeforeCheck = 0;
        };
      };
      accessLog = {};

      metrics = {
        prometheus = {
          addEntryPointsLabels = true;
          entryPoint = "metrics";
        };
      };
    };
    dynamicConfigOptions = {
      http = {
        serversTransports = {unsafe_tls = {insecureSkipVerify = true;};};
        routers = {
          traefik = {
            entryPoints = ["traefik"];
            rule = "Host(`192.168.1.101`) && (PathPrefix(`/dashboard`) || PathPrefix(`/api`))";
            service = "api@internal";
          };
          # matrix = {
          #   rule = "Host(`matrix.strid.ninja`)";
          #   tls = { certResolver = "cloudflare_prod"; };
          #   service = "matrix";
          # };
          # minio = {
          #   rule = "Host(`minio.strid.ninja`)";
          #   tls = { certResolver = "cloudflare_prod"; };
          #   service = "minio";
          # };
          # minio-ui = {
          #   rule = "Host(`minio-ui.strid.ninja`)";
          #   tls = { certResolver = "cloudflare_prod"; };
          #   service = "minio-ui";
          # };
          # resilio = {
          #   rule = "Host(`resilio.strid.ninja`)";
          #   tls = { certResolver = "cloudflare_staging"; };
          #   service = "resilio";
          # };
          unifi = {
            rule = "Host(`unifi.strid.ninja`)";
            tls = {certResolver = "cloudflare_prod";};
            service = "unifi";
          };
          home-assistant = {
            rule = "Host(`homeass.strid.ninja`)";
            tls = {certResolver = "cloudflare_prod";};
            service = "home-assistant";
          };
          nextcloud = {
            rule = "Host(`nextcloud.strid.ninja`)";
            tls = {certResolver = "cloudflare_prod";};
            service = "nextcloud";
          };
          # hedgedoc = {
          #   rule = "Host(`hedgedoc.strid.ninja`)";
          #   tls = { certResolver = "cloudflare_prod"; };
          #   service = "hedgedoc";
          # };
          # vikunja = {
          #   rule = "Host(`todo.strid.ninja`)";
          #   tls = { certResolver = "cloudflare_prod"; };
          #   service = "vikunja";
          # };
          # tandoor = {
          #   rule = "Host(`tandoor.strid.ninja`)";
          #   tls = { certResolver = "cloudflare_prod"; };
          #   service = "tandoor";
          # };
          n8n = {
            rule = "Host(`n8n.strid.ninja`)";
            tls = {certResolver = "cloudflare_prod";};
            service = "n8n";
          };
          # ocaml-nix-updater = {
          #   rule = "Host(`ocaml-nix-updater.strid.ninja`)";
          #   tls = { certResolver = "cloudflare_prod"; };
          #   service = "ocaml-nix-updater";
          # };
          hydra = {
            rule = "Host(`hydra.strid.tech`) || Host(`hydra.strid.ninja`)";
            tls = {certResolver = "cloudflare_prod";};
            service = "hydra";
          };
        };
        services = {
          # matrix = {
          #   loadBalancer = {
          #     servers = [{ url = "http://192.168.1.101:8008"; }];
          #   };
          # };
          # minio = {
          #   loadBalancer = {
          #     servers = [{ url = "http://192.168.1.101:9000"; }];
          #   };
          # };
          # minio-ui = {
          #   loadBalancer = {
          #     servers = [{ url = "http://192.168.1.101:9001"; }];
          #   };
          # };
          # resilio = {
          #   loadBalancer = {
          #     servers = [{ url = "http://192.168.1.101:9080"; }];
          #   };
          # };
          unifi = {
            loadBalancer = {
              serversTransport = "unsafe_tls";
              servers = [{url = "https://192.168.1.1:443";}];
            };
          };
          home-assistant = {
            loadBalancer = {
              servers = [{url = "http://192.168.1.101:8123";}];
            };
          };
          nextcloud = {
            loadBalancer = {
              servers = [{url = "http://192.168.1.101:80";}];
            };
          };
          # hedgedoc = {
          #   loadBalancer = {
          #     servers = [{ url = "http://192.168.1.100:3030"; }];
          #   };
          # };
          # vikunja = {
          #   loadBalancer = {
          #     servers = [{ url = "http://192.168.1.101:3556"; }];
          #   };
          # };
          # tandoor = {
          #   loadBalancer = {
          #     servers = [{ url = "http://192.168.1.101:5080"; }];
          #   };
          # };
          n8n = {
            loadBalancer = {
              servers = [{url = "http://192.168.1.100:5678";}];
            };
          };
          # ocaml-nix-updater = {
          #   loadBalancer = {
          #     servers = [{ url = "http://192.168.1.101:6666"; }];
          #   };
          # };
          hydra = {
            loadBalancer = {
              servers = [{url = "http://192.168.1.101:4000";}];
            };
          };
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [9090 8082 443 80];

  systemd.services.traefik.serviceConfig.EnvironmentFile =
    config.age.secrets.traefik-env.path;

  age.secrets = with config; {
    traefik-env = {
      file = ../secrets/traefik-env.age;
      owner = systemd.services.traefik.serviceConfig.User;
      mode = "0440";
    };
  };
}
