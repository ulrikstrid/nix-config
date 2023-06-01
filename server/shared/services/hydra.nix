{
  config,
  pkgs,
  lib,
  ...
}: let
  narCache = "/var/cache/hydra/nar-cache";
in {
  services.hydra = {
    enable = true;
    debugServer = false;

    useSubstitutes = true;

    port = 4000;
    notificationSender = "hydra@localhost";
    hydraURL = "https://hydra.strid.ninja";
    listenHost = "0.0.0.0";
    extraEnv = {
      AWS_SHARED_CREDENTIALS_FILE = config.age.secrets.aws_credentials.path;
    };
    extraConfig = ''
      using_frontend_proxy 1
      allowed-uris = http:// https:// https://github.com

      store_uri = s3://overlays?endpoint=https://7a53c28e9b7a91239f9ed42da04276bc.r2.cloudflarestorage.com&secret-key=${config.age.secrets.signing_key.path}&write-nar-listing=1&ls-compression=br&log-compression=br
      server_store_uri = https://anmonteiro.nix-cache.workers.dev?local-nar-cache=${narCache}
      binary_cache_public_uri = https://anmonteiro.nix-cache.workers.dev
      queue_runner_metrics_address = 0.0.0.0:9198

      <hydra_notify>
        <prometheus>
          listen_address = 0.0.0.0
          port = 9199
        </prometheus>
      </hydra_notify>

      Include ${config.age.secrets.github_authorizations.path}
    '';
  };
  # Include ${config.age.secrets.githubstatus.path}

  systemd.tmpfiles.rules = [
    "d /var/cache/hydra 0755 hydra hydra -  -"
    "d ${narCache}      0775 hydra hydra 1d -"
  ];

  nix = {
    distributedBuilds = true;
    buildMachines = [
      # {
      #   hostName = "localhost";
      #   maxJobs = 2;
      #   speedFactor = 1;
      #   systems = [ "x86_64-linux" ];
      # }
      {
        hostName = "192.168.1.25";
        maxJobs = 4;
        speedFactor = 4;
        systems = ["x86_64-linux" "aarch64-linux"];
        sshUser = "hydra_builder";
        sshKey = "/var/lib/hydra/.ssh/id_servern2_hydra";
      }
      {
        hostName = "192.168.1.254";
        maxJobs = 4;
        speedFactor = 4;
        systems = ["aarch64-darwin"];
        sshUser = "hydra";
        sshKey = "/var/lib/hydra/.ssh/id_m1mini_hydra";
      }
      {
        hostName = "192.168.1.111";
        maxJobs = 4;
        speedFactor = 1;
        systems = ["aarch64-linux"];
        sshUser = "hydra";
        sshKey = "/var/lib/hydra/.ssh/id_odroid_n2_01";
      }
    ];
  };

  age.secrets = with config; {
    github_authorizations = {
      file = ../secrets/github_authorizations.conf.age;
      owner = config.users.users.hydra.name;
      inherit (config.users.users.hydra) group;
      mode = "0440";
    };
    githubstatus = {
      file = ../secrets/githubstatus.conf.age;
      owner = config.users.users.hydra.name;
      inherit (config.users.users.hydra) group;
      mode = "0440";
    };
    signing_key = {
      file = ../secrets/hydra-signing-key.age;
      owner = config.users.users.hydra.name;
      inherit (config.users.users.hydra) group;
      mode = "0440";
    };
    aws_credentials = {
      file = ../secrets/hydra_aws_credentials.age;
      path = "${config.users.users.hydra-queue-runner.home}/.aws/credentials";
      owner = config.users.users.hydra-queue-runner.name;
      inherit (config.users.users.hydra-queue-runner) group;
      mode = "0440";
    };
  };
}
