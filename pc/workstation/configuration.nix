# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  user = "ulrik";
  userHome = "/home/${user}";
  hostName = "nixos-workstation";
  make_kernelPatch = { name, url, sha256 ? pkgs.lib.fakeSha256, revert ? false }: {
    inherit name;
    patch = (pkgs.fetchpatch {
      inherit name url sha256 revert;
    });
  };
in

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../shared/printer.nix
      ../shared/sound.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [
    #"btusb"
    "btmtk"
    "mt7925e"
  ];

  hardware.enableAllFirmware = true;
  hardware.firmware = [ (pkgs.callPackage ./mt7925-firmware.nix { }) ];

  boot.kernelPatches = [
    {
      name = "Bluetooth: btusb: Add new VID/PID 13d3/3602 for MT7925";
      patch = ./patches/add-mt7925b.patch;
    }
    (make_kernelPatch {
      name = "[v2,1/2] Bluetooth: btusb: mediatek: refactor btusb_mtk_reset function";
      url = "https://patchwork.kernel.org/project/bluetooth/patch/20240102124747.21644-1-hao.qin@mediatek.com/raw/";
      sha256 = "sha256-fHXVak83a0j3C0djb51YZsqU5d8V1EMc1B2pMW18Bn8=";
    })
    (make_kernelPatch {
      name = "[v2,2/2] Bluetooth: btusb: mediatek: add a recovery method for MT7922 and MT7925";
      url = "https://patchwork.kernel.org/project/bluetooth/patch/20240102124747.21644-2-hao.qin@mediatek.com/raw/";
      sha256 = "sha256-L0xRapA463x9/HYQOI1t0hFZGWuz6E1xlCWmlzwqw7g=";
    })
  ];

  networking.hostName = hostName; # Define your hostname.
  # networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "sv_SE.UTF-8";

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.xserver.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "se";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "sv-latin1";

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.fwupd.enable = true;

  hardware.logitech = {
    wireless.enable = true;
    wireless.enableGraphical = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    home = userHome;
    isNormalUser = true;
    description = "Ulrik Strid";
    extraGroups = [ "wheel" "networkmanager" "docker" "audio" "video" "render" "i2c" "libvirtd" "scanner" "lp" ];
  };

  # virtualisation
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.zsh.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  };

  programs.kdeconnect = {
    enable = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.vscode-server.enable = true;

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
  system.stateVersion = "23.05"; # Did you read the comment?

}
