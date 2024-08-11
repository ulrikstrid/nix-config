{ config, pkgs, ... }:
{
  services.stridbot = {
    enable = true;

    envFile = config.age.secrets.stridbot_env.path;
    package = pkgs.stridbot;

    openFirewall = true;
  };

  age.secrets = with config; {
    stridbot_env = {
      file = ../../server/shared/secrets/stridbot_env.age;
      owner = "stridbot";
      group = "stridbot";
      mode = "0440";
    };
  };
}
