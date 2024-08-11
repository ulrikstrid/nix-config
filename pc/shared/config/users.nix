{ config, pkgs, ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    mutableUsers = false;
    users = {
      hydra_builder = {
        home = "/home/hydra_builder";
        description = "Hydra builder";
        isNormalUser = true;
        extraGroups = [ "@builders" ];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEbJgZ4FJhhPLMQm4/lQLu5YhMUBc7HRF6lEtRQ0kqKk ulrik.strid@outlook.com" # nixos-laptop
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIj5X5ga3ZEPxupU8p5wTAHE2t3otcjIrAgAXkA6mUNf ulrik.strid@outlook.com" # workstation
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJk/2qQAHpePeQ99d+QnhygiETRUn/yydEgLoJPZLSy servern@strid.tech" # servern for hydra
        ];
      };

      ulrik = {
        home = "/home/ulrik";
        hashedPassword = "$6$S2p7S1Qlv0Bcx2VD$XNBU0YVajPfGHR1hNncowbIoNOJSMNSkSWaltYbx4wKnWEMra5FaieKVgEw.tbMJllpp6L8hzFvK30I3wOkmL0";
        isNormalUser = true;
        description = "Ulrik Strid";
        shell = pkgs.zsh;
        extraGroups = [
          "wheel"
          "networkmanager"
          "docker"
          "audio"
          "video"
          "render"
          "i2c"
          "libvirtd"
          "scanner"
          "lp"
        ];
      };

      nix-serve = {
        isSystemUser = true;
        group = "nix-serve";
      };
    };

    groups.nix-serve = { };

    groups.plugdev = {
      name = "plugdev";
      members = [ "ulrik" ];
    };
  };
}
