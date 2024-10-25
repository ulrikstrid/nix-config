{
  ...
}:
let
  port = 9010;
in
{
  services.mealie = {
    enable = true;
    inherit port;

    settings = {
      ALLOW_SIGNUP = "true";
    };
  };

  networking.firewall.allowedTCPPorts = [ port ];
}
