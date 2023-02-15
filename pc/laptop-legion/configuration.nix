# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config
, pkgs
, lib
, system
, ...
}:
let
  user = "ulrik";
  userHome = "/home/${user}";
  hostName = "nixos-laptop";
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./sound.nix
    # ../shared/xbox.nix
    # ../shared/kvm.nix
    # ../shared/pgadmin.nix
  ];

  # High quality BT calls
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull;
    hsphfpd.enable = true;
  };

  age.identityPaths = [ "/home/${user}/.ssh/id_ed25519" ];

  hardware.brillo.enable = true;
  hardware.ledger.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "amdgpu.backlight=0" "acpi_backlight=native" ];
  boot.kernelModules = [ "i2c-dev" "i2c-i801" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.grub.extraConfig = ''
    GRUB_CMDLINE_LINUX_DEFAULT="quiet splash amdgpu.backlight=0"
  '';
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.hostName = "${hostName}"; # Define your hostname.
  networking.networkmanager.enable = true;
  # networking.wireless = {
  #  enable = true;  # Enables wireless support via wpa_supplicant.
  #  userControlled.enable = true;
  #};

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp86s0.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  fonts.fonts = with pkgs; [ fira-mono fira-code roboto roboto-mono ];

  services.thermald.enable = true;

  # Disable the nvidia card to 
  hardware.nvidiaOptimus.disable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  specialisation = {
    external-display.configuration = {
      system.nixos.tags = [ "external-display" ];
      hardware.nvidia.modesetting.enable = lib.mkForce true;
      hardware.nvidia.prime.sync.enable = lib.mkForce true;
      hardware.nvidia.prime.offload.enable = lib.mkForce false;
      hardware.nvidia.powerManagement.enable = lib.mkForce true;
      # Enable the nvidia card
      hardware.nvidiaOptimus.disable = lib.mkForce false;
      services.thermald.enable = lib.mkForce false;

      services.xserver.videoDrivers = lib.mkForce [
        "nvidia"
      ];
    };
  };

  hardware.logitech = {
    wireless.enable = true;
    wireless.enableGraphical = true;
  };

  # Enable the X11 windowing system.
  # programs.xwayland.enable = true;
  services.xserver = {
    enable = true;

    # Configure keymap in X11
    layout = "se";
    xkbOptions = "eurosign:e";
    # Enable touchpad support (enabled default in most desktopManager).
    # libinput.enable = true;

    displayManager = {
      # defaultSession = "plasma";
      autoLogin = {
        enable = false;
        user = "ulrik";
      };
    };

    # Enable the KDE Desktop Environment.
    displayManager.sddm = {
      enable = true;
      # wayland = true;
    };

    desktopManager.plasma5 = {
      enable = true;
      useQtScaling = true;
    };
  };

  # services.udev.extraRules = builtins.readFile "${pkgs.openrgb}/etc/udev/rules.d/60-openrgb.rules";

  # Taken from https://github.com/Julusian/node-elgato-stream-deck
  # 0084 is the Stream Deck +
  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0fd9", GROUP="users", TAG+="uaccess"
    SUBSYSTEM=="input", GROUP="input", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0060", MODE:="666", GROUP="plugdev"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0063", MODE:="666", GROUP="plugdev"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="006c", MODE:="666", GROUP="plugdev"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="006d", MODE:="666", GROUP="plugdev"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0080", MODE:="666", GROUP="plugdev"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0084", MODE:="666", GROUP="plugdev"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0086", MODE:="666", GROUP="plugdev"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0090", MODE:="666", GROUP="plugdev"
    KERNEL=="hidraw*", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0060", MODE:="666", GROUP="plugdev"
    KERNEL=="hidraw*", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0063", MODE:="666", GROUP="plugdev"
    KERNEL=="hidraw*", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="006c", MODE:="666", GROUP="plugdev"
    KERNEL=="hidraw*", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="006d", MODE:="666", GROUP="plugdev"
    KERNEL=="hidraw*", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0080", MODE:="666", GROUP="plugdev"
    KERNEL=="hidraw*", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0084", MODE:="666", GROUP="plugdev"
    KERNEL=="hidraw*", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0086", MODE:="666", GROUP="plugdev"
    KERNEL=="hidraw*", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0090", MODE:="666", GROUP="plugdev"
  '';

  services.fwupd.enable = true;

  /*
    services.gnome = {
    gnome-settings-daemon.enable = true;
    gnome-online-accounts.enable = true;
    experimental-features.realtime-scheduling = true;

    games.enable = true;
    };

    # Might be needed for gnome theming
    # services.dbus.packages = with pkgs; [ gnome3.dconf ];
  */

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint pkgs.gutenprintBin ];
  };

  # Enable scanning documents
  hardware.sane.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    home = userHome;
    hashedPassword = "$6$S2p7S1Qlv0Bcx2VD$XNBU0YVajPfGHR1hNncowbIoNOJSMNSkSWaltYbx4wKnWEMra5FaieKVgEw.tbMJllpp6L8hzFvK30I3wOkmL0";
    isNormalUser = true;
    description = "Ulrik Strid";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "docker" "audio" "video" "i2c" "vboxusers" "libvirtd" "plugdev" "scanner" "lp" ];
  };

  # users.extraGroups.vboxusers.members = [ "@wheel" user ];

  users.mutableUsers = false;

  nix = {
    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';

    settings = {
      max-jobs = 4;
      cores = 2;
      allowed-users = [ "@wheel" "@builders" user ];
      trusted-users = [ "root" user ];
      substituters = [
        "https://cache.nixos.org/"
        "https://deku.cachix.org/"
        "https://anmonteiro.nix-cache.workers.dev/"
        "https://nixpkgs-update.cachix.org/"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "deku.cachix.org-1:wvaU5hkNzFLc8euHNB7BAvfr1jWvTPC3t4CnbRV5DxM="
        "anmonteiro.cachix.org-1:KF3QRoMrdmPVIol+I2FGDcv7M7yUajp4F2lt0567VA4="
        "nixpkgs-update.cachix.org-1:6y6Z2JdoL3APdu6/+Iy8eZX2ajf09e4EE9SnxSML1W8="
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    curl
    vim
    mkpasswd
    i2c-tools
    brightnessctl
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

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
  # services.openssh.enable = true;

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
