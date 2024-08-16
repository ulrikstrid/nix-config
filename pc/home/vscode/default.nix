{ pkgs, lib, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    extensions = [
      pkgs.vscode-extensions.ms-vsliveshare.vsliveshare
      pkgs.vscode-extensions.ms-vscode-remote.remote-ssh
      # pkgs.vscode-extensions.ms-azuretools.vscode-bicep
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
