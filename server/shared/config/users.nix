{
  config,
  pkgs,
  ...
}: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    mutableUsers = false;
    users = {
      hydra_builder = {
        home = "/home/hydra_builder";
        description = "Hydra builder";
        isNormalUser = true;
        extraGroups = ["@builders"];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJk/2qQAHpePeQ99d+QnhygiETRUn/yydEgLoJPZLSy servern@strid.tech" # servern for hydra
        ];
      };
      "ulrik.strid" = {
        home = "/home/ulrik.strid";
        description = "Ulrik Strid";
        isNormalUser = true;
        hashedPassword = "$6$hrCi58/8o9qSOeKK$yMjO7P29U5Un2.31O0lGtlitrWl8LHT6tsjMawMWC9A3wNg2nsODeOmkleOrcaA8Vy93p63D0MD.KlAmHlXIM0";
        extraGroups = ["wheel" "nas" "wheel" "rslsync" "docker" "audio"];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEbJgZ4FJhhPLMQm4/lQLu5YhMUBc7HRF6lEtRQ0kqKk ulrik.strid@outlook.com" # which computer is this?
        ];
      };
      sissel = {
        home = "/home/sissel";
        description = "Sissel Strid";
        isNormalUser = true;
        group = "sissel";
        extraGroups = ["nas"];
        hashedPassword = "$6$hrCi58/8o9qSOeKK$yMjO7P29U5Un2.31O0lGtlitrWl8LHT6tsjMawMWC9A3wNg2nsODeOmkleOrcaA8Vy93p63D0MD.KlAmHlXIM0";
      };

      root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEbJgZ4FJhhPLMQm4/lQLu5YhMUBc7HRF6lEtRQ0kqKk ulrik.strid@outlook.com" # nixos-laptop
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIi5Yi3O/s0GYV/reYyM3JZh+6sUr8TjziGm2e4LoNpK ulrik.strid@outlook.com" # m1 mac mini
        # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHTRf7GkQZyCXjnzMTSnFqgEXzb1slneYQp4hrUFdHrR ulrik.strid@outlook.com" # ???
      ];
    };

    groups = {
      sissel = {};
      nas = {name = "nas";};
    };
  };
}
