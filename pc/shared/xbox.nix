{
  config,
  pkgs,
  ...
}: {
  boot.blacklistedKernelModules = ["xpad"];

  systemd.services.xboxdrv = {
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    serviceConfig = {
      Type = "simple";
      User = "root";
      PIDFile = "/var/run/xboxdrv.pid";
      ExecStart = "${pkgs.xboxdrv}/bin/xboxdrv --daemon --dbus disabled --verbose --pid-file /var/run/xboxdrv.pid --detach-kernel-driver --mimic-xpad-wireless --next-controller --next-controller";
    };
  };

  environment.systemPackages = with pkgs; [
    pkgs.xboxdrv
  ];
}
