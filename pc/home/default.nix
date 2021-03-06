{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # gui
    bitwarden
    firefox
    gimp
    joplin-desktop
    libreoffice-fresh
    openrgb
    pavucontrol
    signal-desktop
    slack
    zoom-us
    lutris
    postman
    ferdi
    element-desktop
    chromium

    # utils
    tree
    yq
    jq
    neofetch
    scrcpy
    xboxdrv
    hub
    license-generator
    nixfmt

    # cloud
    kubectl
    kubectx
    kustomize
    fluxcd
    terraform
    terraform-ls
    infracost # estimated cost for terraform
    google-cloud-sdk

    # dev
    shellcheck

    # nix
    nix-zsh-completions
    nixpkgs-fmt
    rnix-lsp
    cachix
    nix-prefetch-git
    nix-prefetch-github

    # encryption
    sops
    age

    # KDE
    kmymoney
    skrooge
    aqbanking # used by skrooge
    libsForQt5.bismuth
    libsForQt5.kbreakout
    libsForQt5.kcalc
    libsForQt5.kmail
    libsForQt5.kalendar
    libsForQt5.kontact
    libsForQt5.kmines
    libsForQt5.kolourpaint

    # gnome
    /* gtk-engine-murrine
       gnome.gnome-tweaks
       gnome.gnome-themes-extra
       gnome.gnome-control-center
       gnomeExtensions.arcmenu
       gnomeExtensions.autohide-battery
       gnomeExtensions.bluetooth-quick-connect
       gnomeExtensions.blur-my-shell
       gnomeExtensions.dash-to-dock
       gnomeExtensions.espresso
       gnomeExtensions.gsconnect
       gnomeExtensions.krypto
       gnomeExtensions.sermon
       gnomeExtensions.taskwhisperer
       gnomeExtensions.tiling-assistant
       gnomeExtensions.timezone
       gnomeExtensions.user-themes
       gnomeExtensions.vitals

       # gnome themes
       nordzy-cursor-theme
       papirus-icon-theme
       nordic
    */
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_USE_XINPUT2 = "1";
  };

  programs.git = {
    enable = true;
    userName = "Ulrik Strid";
    userEmail = "ulrik.strid@outlook.com";

    extraConfig = {
      pull = {
        default = "current";
        rebase = "true";
      };
      rebase = { autosquash = "true"; };
      init.defaultBranch = "main";
    };

    ignores = [ "_build" "_esy" ".env" ];
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      editor = "code";
      prompt = "enabled";
      pager = "bat";
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    cdpath = [ "~/dev" ];
    initExtra = ''export XDG_DATA_HOME="$HOME/.local/share"'';
    dirHashes = {
      dev = "$HOME/dev";
      docs = "$HOME/Documents";
      dl = "$HOME/Downloads";
    };
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "sudo" "kubectl" "gcloud" "terraform" ];
    };
    shellAliases = {
      npf = "nix-prefetch-url --type sha256";
      npfu = "nix-prefetch-url --type sha256 --unpack";
      killall = "pkill -x";
    };
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [ wlrobs obs-nvfbc ];
  };

  programs.taskwarrior = {
    enable = true;
    config = {
      confirmation = false;
      report.minimal.filter = "status:pending";
      report.active.columns =
        [ "id" "start" "entry.age" "priority" "project" "due" "description" ];
      report.active.labels =
        [ "ID" "Started" "Age" "Priority" "Project" "Due" "Description" ];
    };
  };

  programs.bat.enable = true;

  programs.command-not-found.enable = true;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;

    nix-direnv.enable = true;
  };

  services.flameshot.enable = true;

  /* gtk = {
       enable = true;
       theme = {
         package = pkgs.nordic;
         name = "Nordic-darker";
       };

       iconTheme = {
         package = pkgs.papirus-icon-theme;
         name = "Papirus-Dark";
       };

       gtk3.extraConfig = {
         "gtk-application-prefer-dark-theme" = 0;
       };

       gtk4.extraConfig = {
         "gtk-application-prefer-dark-theme" = 0;
       };
     };
  */

  imports = [ ./vscode ];
}
