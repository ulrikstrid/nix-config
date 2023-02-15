# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config
, pkgs
, system
, nixpkgs
, ...
}:
let
  nodeIP = "192.168.1.111";
  nodeHostname = "odroid-n2-01";
in
{
  imports = [
    ../../server/shared/config

    ../../server/shared/services/node-exporter.nix
    ../../server/shared/services/promtail.nix

    ../shared/retro_arch.nix
    ../shared/xbox.nix
  ];

  boot = {
    loader.grub.enable = false;
    loader.generic-extlinux-compatible.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  fileSystems = {
    "/" = {
      label = "NIXOS_SD";
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
      neededForBoot = true;
    };
    /*
      "/nix/store" = {
      # "/dev/disk/by-label/NIX_STORE" should have worked
      label = "NIX_STORE";
      device = "/dev/mmcblk0";
      mountPoint = "/nix/store";
      neededForBoot = true;
      fsType = "btrfs";
      options = [ "noatime" "bind" ];
      };
    */
  };

  networking = {
    hostName = nodeHostname; # Define your hostname.
    extraHosts = "${nodeIP} ${nodeHostname}";
    interfaces.eth0.useDHCP = true;
  };

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ vim wget git ];
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "yes";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 80 443 44365 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall = { enable = true; };

  # collect nix store garbage and optimise daily
  nix.gc.automatic = true;
  nix.optimise.automatic = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

  system.autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable";
}
