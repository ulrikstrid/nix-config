{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    extensions =
      pkgs.vscode-utils.extensionsFromVscodeMarketplace
      (import ./extensions.nix).extensions
      ++ [pkgs.vscode-extensions.ms-vsliveshare.vsliveshare];
    userSettings = {
      "editor.fontFamily" = "'Fira Code', Consolas, 'Courier New', monospace";
      "editor.fontLigatures" = true;
      "editor.formatOnSave" = true;
      "editor.tabSize" = 2;
      "editor.bracketPairColorization.enabled" = true;
      "editor.guides.bracketPairs" = "active";
      "licenser.author" = "Ulrik Strid";
      "licenser.license" = "BSD3";
      "telemetry.enableTelemetry" = false;
      "terminal.integrated.shell.linux" = "zsh";
      "terminal.integrated.shell.osx" = "zsh";
      "workbench.colorTheme" = "Nord Deep";
      "workbench.iconTheme" = "material-icon-theme";
      "nix.enableLanguageServer" = true;
      "[typescript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[javascript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[json]" = {"editor.defaultFormatter" = "esbenp.prettier-vscode";};
      "[nix]" = {"editor.defaultFormatter" = "jnoortheen.nix-ide";};
      "todo-tree.general.tags" = ["BUG" "HACK" "FIXME" "TODO" "XXX" "[ ]"];
      "window.titleBarStyle" = "native";
      "nix.formatterPath" = "alejandra";
    };
  };
}
