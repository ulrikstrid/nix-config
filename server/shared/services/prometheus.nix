{ config, pkgs, lib, ... }:

{
  services.prometheus = {
    enable = true;
    port = 9001;

    scrapeConfigs = [
      {
        job_name = "nuc-01";
        static_configs = [{ targets = [ "192.168.1.100:9002" ]; }];
      }
      {
        job_name = "servern";
        static_configs = [{ targets = [ "192.168.1.101:9002" ]; }];
      }
      {
        job_name = "pi4-01";
        static_configs = [{ targets = [ "192.168.1.110:9002" ]; }];
      }
      # {
      #   job_name = "nixos-desktop";
      #   static_configs = [{
      #     targets = [ "192.168.1.11:9002" ];
      #   }];
      # }
      # {
      #   job_name = "macbook-pro-private";
      #   static_configs = [{
      #     targets = [ "192.168.1.36:9100" ];
      #   }];
      # }
      {
        job_name = "unifi";
        static_configs = [{ targets = [ "192.168.1.100:9130" ]; }];
      }
      {
        job_name = "traefik";
        static_configs = [{ targets = [ "192.168.1.101:8082" ]; }];
      }
      {
        job_name = "minio";
        static_configs = [{ targets = [ "192.168.1.101:9290" ]; }];
      }
      {
        job_name = "redis";
        static_configs = [{ targets = [ "192.168.1.110:9121" ]; }];
      }
      {
        job_name = "postgresql";
        static_configs = [{ targets = [ "192.168.1.101:9187" ]; }];
      }
      {
        job_name = "vikunja";
        static_configs = [{
          targets =
            [ "192.168.1.101:3556" "192.168.1.101:9456" "192.168.1.101:9556" ];
        }];
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [ 9001 ];
}
