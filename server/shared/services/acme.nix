{ config
, pkgs
, lib
, ...
}:
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "ulrik.strid@outlook.com";
  };
}
