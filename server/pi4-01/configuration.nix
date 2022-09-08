# This is a slimmed down version of the config that is generated with
# nixos-generate-config. I removed everything that I understood well
# enough to be sure it is not necessary for working on nixos via ssh.

{ config, pkgs, ... }:
let
  nodeIP = "192.168.1.110";
  nodeHostname = "pi4-01";
in {
  imports = [
    ./hardware-configuration.nix

    # ../../modules/nix-gc.nix
    ../../modules/users.nix
    ../../modules/adguard.nix
  ];

  # nixpkgs.localSystem = pkgs.pkgsCross.aarch64-multiplatform.stdenv.targetPlatform;

  # Make it boot on the RP, taken from here: https://nixos.wiki/wiki/NixOS_on_ARM/Raspberry_Pi_4
  boot = {
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
      raspberryPi.enable = true;
      raspberryPi.version = 4;
    };
    kernelParams = [ "cgroup_memory=1" "cgroup_enable=memory" ];
    kernelPackages = pkgs.linuxPackages_rpi4; # Mainline doesn't work yet
  };

  networking = {
    hostName = nodeHostname;
    extraHosts = "${nodeIP} ${nodeHostname}";
    networkmanager = { enable = true; };

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.eth0.useDHCP = true;
    interfaces.wlan0.useDHCP = true;

    firewall = {
      enable = true;

      allowedTCPPorts = [
        9002 # prometheus node exporter
      ];
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
  };

  services.promtail = {
    enable = true;
    configuration = {
      server = {
        http_listen_port = 28183;
        grpc_listen_port = 0;
      };

      positions.filename = "/tmp/positions.yaml";

      clients = [{ url = "http://192.168.1.100:3100/loki/api/v1/push"; }];

      scrape_configs = [{
        job_name = "journal";
        journal = {
          max_age = "12h";
          labels = {
            job = "systemd-journal";
            host = config.networking.hostName;
          };
        };
        relabel_configs = [{
          source_labels = [ "__journal__systemd_unit" ];
          target_label = "unit";
        }];
      }];
    };
  };

  services.prometheus = {
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };

      redis = {
        enable = true;
        port = 9121;
        openFirewall = true;
      };
    };
  };

  services.redis = {
    enable = true;
    bind = "0.0.0.0";
    openFirewall = true;
    settings = { maxmemory = "512mb"; };
  };

  # packages to install
  environment.systemPackages = with pkgs; [
    git
    vim # doesn't hurt to have an editor on remote.
    nfs-utils
  ];

  nix = {
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    # Free up to 1GiB whenever there is less than 100MiB left.
    extraOptions = ''
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.03"; # Did you read the comment?
}
