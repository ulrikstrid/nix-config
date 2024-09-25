{ pkgs, lib, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    extensions = with pkgs.vscode-extensions; [
      bradlc.vscode-tailwindcss
      codezombiech.gitignore
      eamodio.gitlens
      editorconfig.editorconfig
      esbenp.prettier-vscode
      fill-labs.dependi
      github.vscode-github-actions
      gruntfuggly.todo-tree
      jnoortheen.nix-ide
      ms-dotnettools.vscode-dotnet-runtime
      ms-python.debugpy
      ms-python.python
      ms-python.vscode-pylance
      ms-toolsai.jupyter
      ms-toolsai.jupyter-keymap
      ms-toolsai.jupyter-renderers
      ms-toolsai.vscode-jupyter-cell-tags
      ms-toolsai.vscode-jupyter-slideshow
      ms-vscode-remote.remote-ssh
      ms-vscode-remote.remote-ssh-edit
      ms-vscode.cpptools
      ms-vscode.cpptools-extension-pack
      ms-vscode.powershell
      ms-vsliveshare.vsliveshare
      redhat.vscode-yaml
      rust-lang.rust-analyzer
      tamasfe.even-better-toml
      timonwong.shellcheck
      vscode-icons-team.vscode-icons


      # ms-azuretools.vscode-bicep - Broken
      # ms-azuretools.vscode-docker - Missing?
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace (import ./extensions.nix).extensions;
    userSettings = {
      "editor.fontFamily" = "'Fira Code', Consolas, 'Courier New', monospace";
      "editor.fontLigatures" = true;
      "editor.formatOnSave" = true;
      "editor.tabSize" = 2;
      "editor.bracketPairColorization.enabled" = true;
      "editor.guides.bracketPairs" = "active";
      "licenser.author" = "Ulrik Strid";
      "licenser.license" = "BSD3";
      "telemetry.telemetryLevel" = "off";
      "terminal.integrated.shell.linux" = "zsh";
      "terminal.integrated.shell.osx" = "zsh";
      "workbench.colorTheme" = "Night Owl";
      "workbench.iconTheme" = "vscode-icons";
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "nix.serverSettings" = {
        "nil" = {
          "diagnostics" = { };
          "formatting" = {
            "command" = [ "nixfmt" ];
          };
        };
      };
      "nix.formatterPath" = "nixfmt";
      "[typescript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[TypeScript JSX]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[javascript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[ocaml]" = {
        "editor.defaultFormatter" = "ocamllabs.ocaml-platform";
      };
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[json]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[nix]" = {
        "editor.defaultFormatter" = "jnoortheen.nix-ide";
      };
      "todo-tree.general.tags" = [
        "BUG"
        "HACK"
        "FIXME"
        "TODO"
        "XXX"
        "[ ]"
      ];
      "window.titleBarStyle" = "custom";
      "window.zoomLevel" = 0;
      "dotnetAcquisitionExtension.sharedExistingDotnetPath" = "${pkgs.dotnet-sdk_8}/dotnet";
    };
  };
}
