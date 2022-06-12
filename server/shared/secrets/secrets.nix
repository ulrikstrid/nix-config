let
  ulrikstrid =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEbJgZ4FJhhPLMQm4/lQLu5YhMUBc7HRF6lEtRQ0kqKk";
  users = [ ulrikstrid ];

  m1-mini-01 =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIWgkBKNe921ohqVoXWnfOdeXCFuqg6mIWx/PJLmqsfJ";
  nuc-01 =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMdgqBbUBN1uVJ8+knaKaEZP+EHwreiIbjqGaz3Mrk1G";
  odroid-n2-01 =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKppXbN2n/KthgpI/ORl2pTmAZHDGJ5ZJA+hFWC/vsLK";
  # pi4-01 = "";
  servern =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIATnBocc42HR0vu+x3oYZp3Ya2ROL0enkbbsZva7Vkl4 root@nixos";
  servern2 =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJoyJaqnaqLQCuzlOBapiR/6umAjZZD5qj87LAXQXk4m";
  systems = [ m1-mini-01 nuc-01 odroid-n2-01 servern servern2 ];
in {
  # Hydra
  "github_authorizations.conf.age".publicKeys = users ++ [ servern ];
  "githubstatus.conf.age".publicKeys = users ++ [ servern ];
  # Home assistant
  "home_assistant_google_assistant.json.age".publicKeys = users ++ [ servern ];
  "home_assistant_home_connect.yml.age".publicKeys = users ++ [ servern ];
  "home_assistant_nest.yml.age".publicKeys = users ++ [ servern ];
  "home_assistant_spotify.yml.age".publicKeys = users ++ [ servern ];
  "home_assistant_vacuum.yml.age".publicKeys = users ++ [ servern ];
  # Mosquitto
  "mosquitto-home-assistant.age".publicKeys = users ++ [ servern ];
  "mosquitto-zigbee2mqtt.age".publicKeys = users ++ [ servern nuc-01 ];
  # Trafeik acme
  "traefik-env.age".publicKeys = users ++ [ servern ];
  # Unifi poller credentials
  "unifi-poller.age".publicKeys = users ++ [ nuc-01 ];
}
