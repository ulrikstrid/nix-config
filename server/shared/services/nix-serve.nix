{ config, lib, pkgs, ...}:

{
  services.nix-serve = {
    enable = true;
    openFirewall = true;
    port = 4545;
    secretKeyFile = config.age.secrets.signing_key.path;
    package = pkgs.nix-serve-ng;
  };

  age.secrets = with config; {
    signing_key = {
      file = ../secrets/hydra-signing-key.age;
      owner = "nix-serve";
      group = "nix-serve";
      mode = "0440";
    };
  };
}