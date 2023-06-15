{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
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

    tezos.url = "github:marigold-dev/tezos-nix/main";
    tezos.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    darwin,
    flake-utils,
    nixos-generators,
    agenix,
    tezos,
    ...
  }: let
    perSystem = flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShell =
        pkgs.mkShell {buildInputs = [pkgs.nixpkgs-fmt pkgs.rnix-lsp agenix.packages.${system}.agenix];};

      packages = {
        obs-streamfx = pkgs.qt6Packages.callPackage ./derivations/obs-streamfx.nix {};
      };

      formatter = pkgs.alejandra;
    });
  in
    {
      packages.aarch64-linux = {
        odroid-n2-installer =
          (import ./pc/odroid-n2-01 {
            inherit nixos-generators nixpkgs;
            system = "aarch64-linux";
            pkgs = import nixpkgs {system = "aarch64-linux";};
          })
          .installer;
      };

      packages.x86_64-linux = {
        write-odroid-n2-installer = with nixpkgs.legacyPackages.x86_64-linux;
          writeScriptBin "write-odroid-n2-installer" ''
            path_to_image=$(cat ${self.packages.aarch64-linux.odroid-n2-installer}/nix-support/hydra-build-products | cut -d ' ' -f 3)
            ${zstd}/bin/zstd -d --stdout $path_to_image | ${coreutils}/bin/dd of=$1 bs=4096 conv=fsync status=progress
          '';
      };

      nixosConfigurations = {
        servern = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {inherit system;};
          modules = [
            ./server/servern/configuration.nix
            agenix.nixosModule
          ];
        };

        servern2 = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {inherit system;};
          modules = [
            tezos.nixosModules.x86_64-linux_tezos-node
            tezos.nixosModules.x86_64-linux_tezos-baking
            ./server/servern2/configuration.nix
            agenix.nixosModule
          ];
        };

        nuc-01 = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {inherit system;};
          modules = [./server/nuc-01/configuration.nix agenix.nixosModule];
        };

        odroid-n2-01 = nixpkgs.lib.nixosSystem rec {
          system = "aarch64-linux";
          specialArgs = {inherit system;};
          modules = [
            ./pc/odroid-n2-01/configuration.nix
            agenix.nixosModule
          ];
        };

        nixos-laptop = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {inherit system;};
          pkgs =
            import nixpkgs
            {
              config.allowUnfree = true;
              inherit system;
              overlays = [
                (self: super: {
                  python310 = super.python310.override {
                    packageOverrides = python-self: python-super: {
                      streamdeck = python-super.streamdeck.overrideAttrs (oldAttrs: {
                        src = super.fetchFromGitHub {
                          owner = "ulrikstrid";
                          repo = "python-elgato-streamdeck";
                          rev = "ulrikstrid--streamdeck-plus";
                          sha256 = "sha256-aTxfNPYC7GEd7CrH2NBbAFe5DpswzrE0n0VIlozo2J0=";
                        };

                        propagatedBuildInputs = with super;
                        with python-self; [
                          wheel
                          pillow
                        ];

                        patches = [
                          # substitute libusb path
                          (super.substituteAll {
                            src = ./derivations/streamdeck-hardcode-libusb.patch;
                            hidapi = "${pkgs.hidapi}/lib/libhidapi-libusb${super.stdenv.hostPlatform.extensions.sharedLibrary}";
                          })
                        ];
                      });
                    };
                  };
                })
              ];
            }
            // {
              octez-node = tezos.packages.${system}.octez-node;
              octez-baker = tezos.packages.${system}.octez-baker-PtMumbai;
              octez-accuser = tezos.packages.${system}.octez-accuser-PtMumbai;
            };
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
      };

      darwinConfigurations."m1-mini" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [./server/m1-mini/configuration.nix];
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
