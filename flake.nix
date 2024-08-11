{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-friendly-overlay = {
      url = "github:nixpkgs-friendly/nixpkgs-friendly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stridbot = {
      url = "github:ulrikstrid/stridbot-matrix-ocaml";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix/0.13.0";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-friendly-overlay,
      vscode-server,
      home-manager,
      nixos-hardware,
      darwin,
      flake-utils,
      nixos-generators,
      agenix,
      hyprland,
      stridbot,
      ...
    }:
    let
      perSystem = flake-utils.lib.eachDefaultSystem (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ nixpkgs-friendly-overlay.overlays.default ];
          };
        in
        {
          devShell = pkgs.mkShell {
            buildInputs = [
              pkgs.nixpkgs-fmt
              pkgs.niv
              agenix.packages.${system}.agenix
            ];
          };

          packages = {
            obs-streamfx = pkgs.qt6Packages.callPackage ./derivations/obs-streamfx.nix { };
            mt795-firmware = pkgs.callPackage ./pc/workstation/mt7925-firmware.nix { };
          };

          formatter = pkgs.nixfmt-rfc-style;
        }
      );
    in
    {
      packages.aarch64-linux = {
        odroid-n2-installer =
          (import ./pc/odroid-n2-01 {
            inherit nixos-generators nixpkgs;
            system = "aarch64-linux";
            pkgs = import nixpkgs { system = "aarch64-linux"; };
          }).installer;
      };

      packages.x86_64-linux = {
        write-odroid-n2-installer =
          with nixpkgs.legacyPackages.x86_64-linux;
          writeScriptBin "write-odroid-n2-installer" ''
            path_to_image=$(cat ${self.packages.aarch64-linux.odroid-n2-installer}/nix-support/hydra-build-products | cut -d ' ' -f 3)
            ${zstd}/bin/zstd -d --stdout $path_to_image | ${coreutils}/bin/dd of=$1 bs=4096 conv=fsync status=progress
          '';
      };

      nixosConfigurations =
        let
          x86_64LinuxPkgs = (
            import nixpkgs {
              system = "x86_64-linux";
              overlays = [
                nixpkgs-friendly-overlay.overlays.default
                (final: prev: { stridbot = stridbot.packages.x86_64-linux.default; })
              ];
              # Allow unfree packages
              config.allowUnfree = true;
              nixpkgs.config.cudaSupport = false;
            }
          );
        in
        {
          servern = nixpkgs.lib.nixosSystem rec {
            system = "x86_64-linux";
            specialArgs = {
              inherit system;
            };
            modules = [
              ./server/servern/configuration.nix
              agenix.nixosModule
            ];
          };

          servern2 = nixpkgs.lib.nixosSystem rec {
            system = "x86_64-linux";
            specialArgs = {
              inherit system;
            };
            modules = [
              ./server/servern2/configuration.nix
              agenix.nixosModule
            ];
          };

          nuc-01 = nixpkgs.lib.nixosSystem rec {
            system = "x86_64-linux";
            specialArgs = {
              inherit system;
            };
            modules = [
              ./server/nuc-01/configuration.nix
              agenix.nixosModule
            ];
          };

          odroid-n2-01 = nixpkgs.lib.nixosSystem rec {
            system = "aarch64-linux";
            specialArgs = {
              inherit system;
            };
            modules = [
              ./server/odroid-n2-01/configuration.nix
              agenix.nixosModule
            ];
          };

          nixos-laptop = nixpkgs.lib.nixosSystem rec {
            system = "x86_64-linux";
            specialArgs = {
              inherit system hyprland;
            };
            pkgs = x86_64LinuxPkgs;
            modules = [
              nixos-hardware.nixosModules.lenovo-legion-16ithg6
              nixpkgs.nixosModules.notDetected
              ./pc/laptop-legion/configuration.nix
              home-manager.nixosModules.home-manager
              agenix.nixosModule
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.ulrik = import ./pc/home/default.nix;
              }
            ];
          };

          nixos-workstation = nixpkgs.lib.nixosSystem rec {
            pkgs = x86_64LinuxPkgs;
            system = "x86_64-linux";
            specialArgs = {
              inherit system;
            };
            modules = [
              nixpkgs.nixosModules.notDetected
              nixpkgs-friendly-overlay.nixosModules.default
              stridbot.nixosModules.default
              ./pc/workstation/configuration.nix
              agenix.nixosModule
              vscode-server.nixosModules.default
              (
                { config, pkgs, ... }:
                {
                  services.vscode-server.enable = true;
                }
              )
              home-manager.nixosModules.home-manager
              {
                home-manager.backupFileExtension = "backup";
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.ulrik = import ./pc/home/default.nix;
              }
            ];
          };
        };

      darwinConfigurations."m1-mini" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [ ./server/m1-mini/configuration.nix ];
      };

      hydraJobs = {
        servern = self.nixosConfigurations.servern.config.system.build.toplevel;
        servern2 = self.nixosConfigurations.servern2.config.system.build.toplevel;
        nuc-01 = self.nixosConfigurations.nuc-01.config.system.build.toplevel;
        nixos-laptop = self.nixosConfigurations.nixos-laptop.config.system.build.toplevel;
      };
    }
    // perSystem;
}
