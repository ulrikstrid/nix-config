{pkgs, ...}: {
  nix = {
    settings = {
      allowed-users = [
        "@wheel"
        "@builders"
        "@hydra"
        "ulrik.strid"
        "hydra_builder"
        "hydra-queue-runner"
      ];
      trusted-users = ["root" "ulrik.strid" "hydra_builder" "hydra-queue-runner"];
      auto-optimise-store = true;
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      allowed-uris = http:// https:// https://github.com/
      # Free up to 2GiB whenever there is less than 512MiB left.
      min-free = ${toString (512 * 1024 * 1024)}
      max-free = ${toString (2 * 1024 * 1024 * 1024)}
    '';

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
