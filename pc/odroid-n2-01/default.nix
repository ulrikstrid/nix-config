{ pkgs, nixos-generators, nixpkgs, system, ... }:

{
  installer = nixos-generators.nixosGenerate {
    inherit pkgs system;

    format = "sd-aarch64-installer";
    modules = [ ./configuration.nix ];
  };
}
