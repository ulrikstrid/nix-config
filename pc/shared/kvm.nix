{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ virt-manager ];

  programs.dconf.enable = true;

  virtualisation.libvirtd = {
    enable = true;
  };
}
