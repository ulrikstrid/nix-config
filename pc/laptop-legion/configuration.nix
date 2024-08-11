# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  system,
  hyprland,
  ...
}:
let
  user = "ulrik";
  hostName = "nixos-laptop";
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../shared/sound.nix
    # ../shared/xbox.nix
    # ../shared/kvm.nix
    # ../shared/pgadmin.nix
    ../shared/printer.nix
    ../shared/nix-settings.nix
    ./nvidia.nix
    ./wireguard.nix
    ../shared/config/users.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.extraConfig = ''
    GRUB_CMDLINE_LINUX_DEFAULT="quiet splash amdgpu.backlight=0"
  '';
  boot.loader.grub.useOSProber = true;

  boot.kernelParams = [
    "amdgpu.backlight=0"
    "acpi_backlight=native"
  ];
  boot.kernelModules = [
    "i2c-dev"
    "i2c-i801"
  ];
  boot.extraModulePackages = [ config.boot.kernelPackages.lenovo-legion-module ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # High quality BT calls
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluez;
    hsphfpd.enable = false;
  };

  age.identityPaths = [ "/home/${user}/.ssh/id_ed25519" ];

  hardware.brillo.enable = true;
  hardware.ledger.enable = true;

  networking.hostName = "${hostName}"; # Define your hostname.
  networking.networkmanager.enable = true;
  # networking.wireless = {
  #  enable = true;  # Enables wireless support via wpa_supplicant.
  #  userControlled.enable = true;
  #};

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp86s0.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.extraHosts = ''
    127.0.0.1 www.contoso.com
  '';

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "sv_SE.UTF-8";
  i18n.supportedLocales = [
    (config.i18n.defaultLocale + "/UTF-8")
    "en_US.UTF-8/UTF-8"
  ];

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  fonts.packages = with pkgs; [
    fira-mono
    fira-code
    roboto
    roboto-mono
  ];

  services.thermald.enable = true;

  specialisation = {
    no-gpu.configuration = {
      system.nixos.tags = [ "no-gpu" ];
      hardware.nvidia.prime.offload.enable = lib.mkForce true;
      hardware.nvidia.prime.sync.enable = lib.mkForce false;
      # Disable the nvidia card
      hardware.nvidiaOptimus.disable = lib.mkForce false;
      hardware.nvidia.powerManagement.finegrained = lib.mkForce true;
    };
    # This doesn't seem to work correctly, remove for now
    # no-gpu-ext-d.configuration = {
    #   system.nixos.tags = [ "no-gpu-ext-d" ];
    #   hardware.nvidia.prime.offload.enable = lib.mkForce false;
    # Disable the nvidia card
    #   hardware.nvidiaOptimus.disable = lib.mkForce true;
    #   hardware.nvidia.powerManagement.finegrained = lib.mkForce false;
    # };
  };

  hardware.logitech = {
    wireless.enable = true;
    wireless.enableGraphical = true;
  };

  services.displayManager = {
    autoLogin = {
      inherit user;
      enable = false;
    };
    sddm = {
      enable = true;
      enableHidpi = true;
      wayland.enable = true;
    };
  };

  services.xserver = {
    # Configure keymap in X11
    xkb.layout = "se";
    xkb.options = "eurosign:e";
  };

  services.desktopManager.plasma6 = {
    enable = true;
  };

  programs.hyprland = {
    enable = true;
    # package = hyprland.packages.${system}.hyprland;
  };

  services.fwupd.enable = true;

  # Enable scanning documents
  hardware.sane.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    curl
    vim
    mkpasswd
    i2c-tools
    brightnessctl
    pciutils
    lenovo-legion
    ntfs3g
    nvidia-offload
  ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  security.polkit.enable = true;
  /*
    Good snippet for debugging polkit
    security.polkit.debug = true;
    security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
    // Make sure to set { security.polkit.debug = true; } in configuration.nix
    polkit.log("user " +  subject.user + " is attempting action " + action.id + " from PID " + subject.pid);
    });

    polkit.addRule(function (action, subject) {
    if (subject.local) return polkit.Result.YES;
    });
    '';
  */

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.zsh.enable = true;

  programs.dconf.enable = true;
  programs.droidcam.enable = true;

  programs.kdeconnect = {
    enable = true;
    # package = pkgs.gnomeExtensions.gsconnect;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  };

  # List services that you want to enable:
  services.flatpak.enable = false;
  services.onedrive.enable = true;
  services.acpid.enable = true;
  hardware.acpilight.enable = true;
  services.hardware.bolt.enable = true;

  # Better battery life in theory
  services.power-profiles-daemon.enable = true;
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune = {
        enable = true;
        flags = [ "--all" ];
      };
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
  system.autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable";
}
