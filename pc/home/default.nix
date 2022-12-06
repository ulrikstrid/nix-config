{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    # gui
    bitwarden
    firefox
    gimp
    joplin-desktop
    libreoffice-fresh
    pavucontrol
    signal-desktop
    slack
    zoom-us
    lutris
    postman
    ferdium
    element-desktop
    chromium
    ledger-live-desktop
    freerdp

    # laptop rgb
    openrgb
    i2c-tools

    # utils
    tree
    yq
    jq
    neofetch
    scrcpy
    xboxdrv
    hub
    license-generator
    gnumake
    git-crypt

    # cloud
    kubectl
    kubectx
    kustomize
    fluxcd
    terraform
    terraform-ls
    google-cloud-sdk

    # dev
    shellcheck

    # nix
    nix-zsh-completions
    nix-prefetch-git
    nix-prefetch-github

    # encryption
    sops
    rage

    # KDE
    libsForQt5.kcalc
    libsForQt5.kmail
    libsForQt5.kalendar
    libsForQt5.kontact
    libsForQt5.kolourpaint
    libsForQt5.plasma-browser-integration
    libsForQt5.ark

    # gnome
    /*
     gtk-engine-murrine
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
    EDITOR = "nvim";
    SHELL = "zsh";
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
      push = {
        autoSetupRemote = "true";
      };
      rebase = {autosquash = "true";};
      init.defaultBranch = "main";
    };

    ignores = ["_build" "_esy" ".env"];
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
    cdpath = ["~/dev"];
    initExtra = ''export XDG_DATA_HOME="$HOME/.local/share"'';
    dirHashes = {
      dev = "$HOME/dev";
      docs = "$HOME/Documents";
      dl = "$HOME/Downloads";
    };
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = ["git" "sudo" "kubectl" "gcloud" "terraform"];
    };
    shellAliases = {
      npf = "nix-prefetch-url --type sha256";
      npfu = "nix-prefetch-url --type sha256 --unpack";
      killall = "pkill -x";
    };
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-pipewire-audio-capture
      obs-backgroundremoval
      obs-multi-rtmp
      (pkgs.callPackage ../../derivations/droidcam-obs.nix {})
    ];
  };

  programs.taskwarrior = {
    enable = true;
    config = {
      confirmation = false;
      report.minimal.filter = "status:pending";
      report.active.columns = ["id" "start" "entry.age" "priority" "project" "due" "description"];
      report.active.labels = ["ID" "Started" "Age" "Priority" "Project" "Due" "Description"];
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

  /*
   gtk = {
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

  imports = [./vscode ./nvim];

  # https://rycee.gitlab.io/home-manager/options.html#opt-home.stateVersion
  home.stateVersion = "22.11";
}
