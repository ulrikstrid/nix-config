{ config
, pkgs
, lib
, user
, ...
}:
let
  user = "ulrik";
in
{
  nix = {
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';

    settings = {
      allowed-users = [ "@wheel" "@builders" "hydra_builder" user ];
      trusted-users = [ "root" user ];
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://ocaml.nix-cache.com"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "ocaml.nix-cache.com-1:/xI2h2+56rwFfKyyFVbkJSeGqSIYMC/Je+7XXqGKDIY="
      ];
      # Enable flakes
      experimental-features = [ "nix-command" "flakes" ];
    };
  };
}
