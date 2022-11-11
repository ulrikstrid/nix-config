{
  config,
  pkgs,
  lib,
  ...
}: {
  services.prometheus = {
    enable = true;
    port = 9001;

    scrapeConfigs = [
      {
        job_name = "nuc-01";
        static_configs = [{targets = ["192.168.1.100:9002"];}];
      }
      {
        job_name = "servern";
        static_configs = [{targets = ["192.168.1.101:9002"];}];
      }
      {
        job_name = "servern2";
        static_configs = [{targets = ["192.168.1.25:9002"];}];
      }
      {
        job_name = "hydra";
        scheme = "https";
        static_configs = [{targets = ["hydra.strid.ninja"];}];
      }
      {
        job_name = "hydra_notify";
        static_configs = [{targets = ["192.168.1.101:9199"];}];
      }
      {
        job_name = "hydra_queue_runner";
        scheme = "https";
        tls_config = {
          insecure_skip_verify = true;
        };
        static_configs = [{targets = ["192.168.1.101:9198"];}];
      }
      {
        job_name = "unifi";
        static_configs = [{targets = ["192.168.1.100:9130"];}];
      }
      {
        job_name = "traefik";
        static_configs = [{targets = ["192.168.1.101:8082"];}];
      }
      {
        job_name = "minio";
        static_configs = [{targets = ["192.168.1.101:9290"];}];
      }
      {
        job_name = "redis";
        static_configs = [{targets = ["192.168.1.110:9121"];}];
      }
      {
        job_name = "postgresql";
        static_configs = [{targets = ["192.168.1.101:9187"];}];
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [9001];
}
