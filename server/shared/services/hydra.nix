{ config, pkgs, lib, ... }: {
  services.hydra-dev = {
    enable = true;
    debugServer = true;

    useSubstitutes = true;

    port = 4000;
    notificationSender = "hydra@localhost";
    hydraURL = "https://hydra.strid.ninja";
    listenHost = "0.0.0.0";
    extraConfig = ''
      using_frontend_proxy 1
      base_uri hydra.strid.tech
      allowed-uris = http:// https:// https://github.com

      Include ${config.age.secrets.github_authorizations.path}
      Include ${config.age.secrets.githubstatus.path}
    '';
  };

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
        systems = [ "x86_64-linux" "aarch64-linux" ];
        sshUser = "hydra_builder";
        sshKey = "/var/lib/hydra/.ssh/id_servern2_hydra";
      }
      {
        hostName = "192.168.1.254";
        maxJobs = 4;
        speedFactor = 4;
        systems = [ "aarch64-darwin" ];
        sshUser = "hydra";
        sshKey = "/var/lib/hydra/.ssh/id_m1mini_hydra";
      }
      {
        hostName = "192.168.1.111";
        maxJobs = 4;
        speedFactor = 1;
        systems = [ "aarch64-linux" ];
        sshUser = "hydra";
        sshKey = "/var/lib/hydra/.ssh/id_odroid_n2_01";
      }
    ];
  };

  age.secrets = with config; {
    github_authorizations = {
      file = ../secrets/github_authorizations.conf.age;
      owner = config.users.users.hydra.name;
      group = config.users.users.hydra.group;
      mode = "0440";
    };
    githubstatus = {
      file = ../secrets/githubstatus.conf.age;
      owner = config.users.users.hydra.name;
      group = config.users.users.hydra.group;
      mode = "0440";
    };
  };
}
