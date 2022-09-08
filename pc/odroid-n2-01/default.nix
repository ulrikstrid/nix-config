{ pkgs, nixos-generators, nixpkgs, ... }:

{
  installer = nixos-generators.nixosGenerate {
    inherit pkgs;

    format = "sd-aarch64-installer";
    modules = [ ./configuration.nix ];
  };
}
