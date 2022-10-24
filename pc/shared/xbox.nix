{ config, pkgs, ... }:

{
  boot.blacklistedKernelModules = [ "xpad" ];

  systemd.services.xboxdrv = {
    wantedBy = [ "multi-user.target" ]; 
    after = [ "network.target" ];
    serviceConfig = {   
      Type = "forking";
      User = "root";
      ExecStart = "${pkgs.xboxdrv}/bin/xboxdrv --daemon --detach --pid-file /var/run/xboxdrv.pid --dbus disabled --silent --detach-kernel-driver --deadzone 4000 --deadzone-trigger 10% --mimic-xpad-wireless";
    };
  };

  environment.systemPackages = with pkgs; [
    pkgs.xboxdrv
  ];
}