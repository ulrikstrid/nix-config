# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config
, pkgs
, system
, ...
}:
let
  nodeIP = "192.168.1.100";
  nodeHostname = "nuc-01";
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Base config
    ../shared/config

    # Services
    ../shared/services/grafana.nix
    ../shared/services/loki.nix
    ../shared/services/n8n.nix
    ../shared/services/node-exporter.nix
    ../shared/services/prometheus.nix
    ../shared/services/promtail.nix
    ../shared/services/unifi-poller.nix
    ../shared/services/zigbee2mqtt.nix
    ../shared/services/zwavejs2mqtt.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = nodeHostname; # Define your hostname.
  networking.extraHosts = "${nodeIP} ${nodeHostname}";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ git wget vim bind nfs-utils ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 80 443 44365 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall = { enable = true; };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

  system.autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable";
}
