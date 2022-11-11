{
  config,
  pkgs,
  lib,
  ...
}: {
  services.minio = {
    enable = true;
    browser = true;

    region = "eu-north-1";

    # this is fine, but we might want to use age here as well
    rootCredentialsFile = "/nas/minio/minio-root-credentials";
    configDir = "/nas/minio/config";
    dataDir = ["/nas/minio/data"];
  };

  services.prometheus.exporters.minio = {
    enable = true;
    minioBucketStats = true;
    port = 9290;
    openFirewall = true;
  };
}
