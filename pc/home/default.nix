{ config
, pkgs
, lib
, ...
}:
let
  google-cloud-sdk-c = pkgs.google-cloud-sdk.withExtraComponents (with pkgs.google-cloud-sdk.components; [
    cloud-build-local
    gke-gcloud-auth-plugin
  ]);
in
{
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
    psensor
    # zoom-us
    lutris
    postman
    ferdium
    element-desktop
    chromium
    microsoft-edge
    ledger-live-desktop

    # laptop rgb
    # openrgb
    # i2c-tools

    # utils
    tree
    yq
    jq
    neofetch
    scrcpy
    # xboxdrv
    hub
    # license-generator
    gnumake
    # git-crypt

    # cloud
    kubectl
    kubectx
    kustomize
    fluxcd
    terraform
    terraform-ls
    google-cloud-sdk-c

    # dev
    shellcheck

    # nix
    nix-zsh-completions
    nix-prefetch-git
    nix-prefetch-github
    rnix-lsp
    alejandra

    # Lua (neovim)
    # sumneko-lua-language-server
    # stylua

    # encryption
    sops
    rage

    # KDE
    libsForQt5.kcalc
    libsForQt5.kolourpaint
    libsForQt5.plasma-browser-integration
    libsForQt5.ark
    libsForQt5.skanpage
    libsForQt5.powerdevil
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    SHELL = "zsh";
    USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
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
    syntaxHighlighting.enable = true;
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
      plugins = [ "direnv" "kubectl" "gcloud" ];
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
      # wlrobs
      # obs-pipewire-audio-capture
      # obs-backgroundremoval
      # obs-multi-rtmp
      droidcam-obs
    ];
  };

  programs.taskwarrior = {
    enable = true;
    config = {
      confirmation = false;
      report.minimal.filter = "status:pending";
      report.active.columns = [ "id" "start" "entry.age" "priority" "project" "due" "description" ];
      report.active.labels = [ "ID" "Started" "Age" "Priority" "Project" "Due" "Description" ];
    };
  };

  programs.bat.enable = true;

  programs.command-not-found.enable = true;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;

    nix-direnv.enable = true;
  };

  programs.kitty = {
    enable = true;
    theme = "Night Owl";
    font.name = "Fira Code";
    font.package = pkgs.fira-code;
  };

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

  imports = [ ./vscode ./nvim ];

  # https://rycee.gitlab.io/home-manager/options.html#opt-home.stateVersion
  home.stateVersion = "22.11";
}
