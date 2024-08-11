{ pkgs, config, ... }: {
  networking.wg-quick.interfaces = let
    server_ip = "home.strid.ninja";
  in {
    wg0 = {
      # IP address of this machine in the *tunnel network*
      address = [
        "192.168.3.2/32"
      ];

      # To match firewall allowedUDPPorts (without this wg
      # uses random port numbers).
      listenPort = 51821;

      # Path to the private key file.
      privateKeyFile = config.age.secrets.wireguard_vpn_laptop_key.path;

      peers = [{
        publicKey = "kxU59YImF+J56MK3/kWZz31HrfKfRFJMMEAXkhKznXs=";
        allowedIPs = [ "192.168.3.1/32,192.168.3.2/32,0.0.0.0/0" ];
        endpoint = "${server_ip}:51821";
        persistentKeepalive = 25;
      }];
    };
  };

  age.secrets = with config; {
    wireguard_vpn_laptop_key = {
      file = ../../server/shared/secrets/wireguard-vpn-laptop.age;
      owner = "ulrik";
      group = "ulrik";
      mode = "0400";
    };
  };
}
