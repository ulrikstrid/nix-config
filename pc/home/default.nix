{
  config,
  pkgs,
  lib,
  ...
}:
let
  google-cloud-sdk-c = pkgs.google-cloud-sdk.withExtraComponents (
    with pkgs.google-cloud-sdk.components;
    [
      cloud-build-local
      gke-gcloud-auth-plugin
    ]
  );
in
{
  home.packages = with pkgs; [
    # gui
    bitwarden
    firefox
    gimp
    inkscape
    joplin-desktop
    # pavucontrol
    signal-desktop
    slack
    # psensor
    thunderbird
    ferdium
    discord
    element-desktop
    microsoft-edge
    # ledger-live-desktop
    # godot_4
    insomnia

    # utils
    tree
    yq
    jq
    neofetch
    scrcpy
    # xboxdrv
    # hub
    gnumake

    # cloud
    kubectl
    kubectx
    kustomize
    fluxcd

    # dev
    shellcheck
    devenv
    pkgs.dotnet-sdk_9

    # nix
    nix-zsh-completions
    nix-prefetch-git
    nix-prefetch-github
    nixfmt-rfc-style
    nil

    # encryption
    sops
    rage

    # KDE
    kdePackages.kcalc
    kdePackages.kolourpaint
    kdePackages.skanpage

    # Workstation specfic
    # TODO: How can we add this only for workstation?
    amdgpu_top

    # Games
    lutris
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    SHELL = "${pkgs.zsh}/bin/zsh";
  };

  imports = [
    ./vscode
  ];

  programs.git = {
    enable = true;
    userName = "Ulrik Strid";
    userEmail = "ulrik@strid.tech";

    extraConfig = {
      pull = {
        default = "current";
        rebase = "true";
      };
      push = {
        autoSetupRemote = "true";
      };
      rebase = {
        autosquash = "true";
      };
      init.defaultBranch = "main";
      sendemail = {
        from = "ulrik@strid.tech";
        smtpServer = "smtp.office365.com";
        smtpServerPort = 587;
        smtpEncryption = "tls";
        smtpUser = "ulrik@strid.tech";
      };
      credential.helper = "store";
    };

    ignores = [
      "_build"
      "_esy"
      ".env"
    ];
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
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    cdpath = [
      "~/dev"
      "~/dev/stridtech"
    ];
    initContent = ''
      export XDG_DATA_HOME="$HOME/.local/share"
    '';
    dirHashes = {
      dev = "$HOME/dev";
      docs = "$HOME/Documents";
      dl = "$HOME/Downloads";
    };
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "direnv"
        "kubectl"
      ];
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
      # droidcam-obs
    ];
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
    themeFile = "night_owl";
    font.name = "Fira Code";
    font.package = pkgs.fira-code;
    shellIntegration.enableZshIntegration = true;
  };

  # https://rycee.gitlab.io/home-manager/options.html#opt-home.stateVersion
  home.stateVersion = "22.11";
}
