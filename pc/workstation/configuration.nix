# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  nixos-hardware,
  ...
}:

let
  user = "ulrik";
  hostName = "nixos-workstation";

  dotnet-sdk = pkgs.dotnet-sdk_9;
  dotnetRoot = "${dotnet-sdk}/share/dotnet";
in

{
  imports = [
    nixos-hardware.nixosModules.common-gpu-amd
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-cpu-amd-pstate
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    
    ../shared/printer.nix
    ../shared/sound.nix
    ../shared/i18n.nix
    ../shared/nix-settings.nix

    ../shared/zsh.nix
    ../shared/docker.nix
    ../shared/stridbot.nix
    # ../shared/flatpak.nix
    ../shared/ollama.nix
    ../shared/config/users.nix
    ../../server/shared/services/nix-serve.nix

    ./bluetooth-fix.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages;
  boot.kernelModules = [
    "btusb"
    "btmtk"
    "mt7925e"
  ];
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  hardware.enableAllFirmware = true;
  hardware.firmware = [ (pkgs.callPackage ./mt7925-firmware.nix { }) ];
  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
    rocmPackages.rocm-runtime
  ];
  hardware.graphics.enable = true;
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    "L+    /opt/rocm/lib   -    -    -     -    ${pkgs.rocmPackages.clr}/lib"
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "se";
    variant = "";
  };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
    };
    autoLogin.enable = false;
    autoLogin.user = user;
  };
  services.desktopManager.plasma6.enable = true;

  # Configure console keymap
  console.keyMap = "sv-latin1";

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  age.identityPaths = [ "/home/${user}/.ssh/id_ed25519" ];

  services.fwupd.enable = true;

  hardware.logitech = {
    wireless.enable = true;
    wireless.enableGraphical = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # virtualisation
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    clinfo
    dotnet-sdk
  ];

  environment.etc = {
    "dotnet/install_location".text = dotnetRoot;
  };

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
  
  programs.streamcontroller.enable = true;

  # List services that you want to enable:

  services.esphome = {
    enable = true;
    openFirewall = true;
    allowedDevices = [
      "char-ttyS"
      "char-ttyUSB"
      "/dev/ttyUSB0"
    ];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 3000 ]; # Temporary
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Update /etc/hosts
  networking.extraHosts = ''
    127.0.0.1 www.contoso.com # add for testing our certificate
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
