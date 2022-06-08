{ ... }:

{
  services.samba = {
    enable = true;
    enableNmbd = true;
    openFirewall = true;
    securityType = "user";
    invalidUsers = [ "root" ];
    extraConfig = ''
      workgroup = WORKGROUP
      server string = servern
      server role = standalone server
      netbios name = servern
      # use sendfile = yes
      # max protocol = smb2
      # hosts allow = 192.168.1  localhost
      # hosts deny = 0.0.0.0/0
      # guest account = nobody
      # map to guest = nobody
    '';
    shares = {
      nas = {
        path = "/nas";
        browseable = "yes";
        "writable" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "comment" = "Gamla naset";
      };
      private = {
        path = "/mnt/diskendisken";
        browseable = "yes";
        "writable" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
      };
    };
  };
}
