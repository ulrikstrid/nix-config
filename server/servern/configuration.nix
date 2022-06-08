# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  nodeIP = "192.168.1.101";
  nodeHostname = "servern";
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Base config
    ../shared/config

    # Services
    ../shared/services/minio.nix
    ../shared/services/home-assistant.nix
    ../shared/services/traefik.nix
    ../shared/services/mosquitto.nix
    ../shared/services/node-exporter.nix
    ../shared/services/promtail.nix
    ../shared/services/postgres.nix
    ../shared/services/tandoor.nix
    ../shared/services/adguard.nix
    # ../shared/services/ocaml-nix-updater.nix
    ../shared/services/hydra.nix
    ../shared/services/samba.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelParams = [ "cgroup_memory=1" "cgroup_enable=memory" ];
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  networking = {
    hostName = nodeHostname;
    extraHosts = "${nodeIP} ${nodeHostname}";

    nameservers = [ "192.168.1.1" "1.1.1.1" "1.0.0.1" ];

    # Open ports in the firewall
    firewall = { enable = true; };

    networkmanager = { enable = true; };
  };

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ git wget vim bind nfs-utils ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  services.rpcbind.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
