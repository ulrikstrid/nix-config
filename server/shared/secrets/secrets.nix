let
  ulrikstrid = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEbJgZ4FJhhPLMQm4/lQLu5YhMUBc7HRF6lEtRQ0kqKk";
  users = [ ulrikstrid ];

  m1-mini-01 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIWgkBKNe921ohqVoXWnfOdeXCFuqg6mIWx/PJLmqsfJ";
  nuc-01 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMdgqBbUBN1uVJ8+knaKaEZP+EHwreiIbjqGaz3Mrk1G";
  odroid-n2-01 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKppXbN2n/KthgpI/ORl2pTmAZHDGJ5ZJA+hFWC/vsLK";
  # pi4-01 = "";
  servern =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIATnBocc42HR0vu+x3oYZp3Ya2ROL0enkbbsZva7Vkl4";
  servern2 =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJoyJaqnaqLQCuzlOBapiR/6umAjZZD5qj87LAXQXk4m";
  systems = [ m1-mini-01 nuc-01 odroid-n2-01 servern servern2 ];
in
{
  "unifi-poller.age".publicKeys = users ++ [ nuc-01 ];
}
