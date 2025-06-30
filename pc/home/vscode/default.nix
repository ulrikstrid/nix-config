{ pkgs, lib, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    mutableExtensionsDir = false;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        bradlc.vscode-tailwindcss
        codezombiech.gitignore
        eamodio.gitlens
        editorconfig.editorconfig
        esbenp.prettier-vscode
        fill-labs.dependi
        geequlim.godot-tools
        github.copilot
        github.copilot-chat
        github.vscode-github-actions
        github.vscode-pull-request-github
        golang.go
        gruntfuggly.todo-tree
        hashicorp.terraform
        ionide.ionide-fsharp
        jnoortheen.nix-ide
        jock.svg
        ms-azuretools.vscode-docker
        ms-dotnettools.csdevkit
        ms-dotnettools.csharp
        ms-dotnettools.vscode-dotnet-runtime
        ms-kubernetes-tools.vscode-kubernetes-tools
        ms-vscode-remote.remote-ssh
        ms-vscode-remote.remote-ssh-edit
        ms-vscode.cmake-tools
        ms-vscode.cpptools
        ms-vscode.cpptools-extension-pack
        ms-vscode.makefile-tools
        ms-vscode.powershell
        ms-vsliveshare.vsliveshare
        ocamllabs.ocaml-platform
        redhat.vscode-yaml
        rust-lang.rust-analyzer
        sdras.night-owl
        timonwong.shellcheck
        vscode-icons-team.vscode-icons
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace (import ./extensions.nix).extensions;
      userSettings = {
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
        "[json]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
        };
        
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
        "editor.bracketPairColorization.enabled" = true;
        "editor.fontFamily" = "'Fira Code', Consolas, 'Courier New', monospace";
        "editor.fontLigatures" = true;
        "editor.formatOnSave" = true;
        "editor.guides.bracketPairs" = "active";
        "editor.tabSize" = 2;
        "telemetry.telemetryLevel" = "off";
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

        "dotnetAcquisitionExtension.sharedExistingDotnetPath" = "${pkgs.dotnet-sdk_9}/bin/dotnet";
        "dotnetAcquisitionExtension.existingDotnetPath" = [
                    {
            "extensionId" = "ms-dotnettools.csharp";
            "path" = "${pkgs.dotnet-sdk_9}/bin/dotnet";
          }
          {
            "extensionId" = "ms-dotnettools.csdevkit";
            "path" = "${pkgs.dotnet-sdk_9}/bin/dotnet";
          }
          {
            "extensionId" = "ms-azuretools.vscode-bicep";
            "path" = "${pkgs.dotnet-sdk_8}/bin/dotnet";
          }
          {
            "extensionId" = "ms-azuretools.vscode-azure-github-copilot";
            "path" = "${pkgs.dotnet-sdk_8}/bin/dotnet";
          }
        ];
        "omnisharp" = {
          "path" = "${pkgs.omnisharp-roslyn}/bin/OmniSharp";
          "sdkPath" = "${pkgs.dotnet-sdk_9}";
          "dotnetPath" = "${pkgs.dotnet-sdk_9}/bin/dotnet";
        };

        "godotTools.lsp.serverPort" = 6005; # port should match your Godot configuration

      };
    };
  };
}