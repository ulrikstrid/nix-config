{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-generators = {
      url = "github:/nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";

    hydra = { url = "github:NixOS/hydra"; };

    # ocaml-nix-updater.url = "github:ulrikstrid/ocaml-nix-updater";
    # ocaml-nix-updater.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils-plus = {
      url = "github:gytis-ivaskevicius/flake-utils-plus";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, hydra, darwin
    , flake-utils-plus, nixos-generators, agenix, ... }:
    let
      devShell = flake-utils-plus.lib.eachDefaultSystem (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          devShell =
            pkgs.mkShell { buildInputs = [ pkgs.nixpkgs-fmt pkgs.rnix-lsp ]; };
        });
    in {
      packages.aarch64-linux = {
        odroid-n2-installer = (import ./server/odroid-n2-01 {
          inherit nixos-generators nixpkgs;
          pkgs = (import nixpkgs { system = "aarch64-linux"; });
        }).installer;
      };
      nixosConfigurations = {
        servern = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = { inherit system; };
          modules = [
            ./server/servern/configuration.nix
            agenix.nixosModule
            hydra.nixosModules.hydra
          ];
        };

        servern2 = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = { inherit system; };
          modules = [ ./server/servern2/configuration.nix agenix.nixosModule ];
        };

        nuc-01 = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = { inherit system; };
          modules = [ ./server/nuc-01/configuration.nix agenix.nixosModule ];
        };

        odroid-n2-01 = nixpkgs.lib.nixosSystem rec {
          system = "aarch64-linux";
          specialArgs = { inherit system; };
          modules =
            [ ./server/odroid-n2-01/configuration.nix agenix.nixosModule ];
        };

        nixos-laptop = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = { inherit system; };
          modules = [
            nixpkgs.nixosModules.notDetected
            ./pc/nixos-laptop/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.ulrik = import ./home/default.nix;
            }
          ];
        };
      };

      darwinConfigurations."m1-mini" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [ ./server/m1-mini/configuration.nix ];
      };

      hydraJobs = {
        servern = self.nixosConfigurations.servern;
        servern2 = self.nixosConfigurations.servern2;
        nuc-01 = self.nixosConfigurations.nuc-01;
      };
    } // devShell;
}
