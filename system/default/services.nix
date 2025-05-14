{ hostname, primaryUser }:
{ config, pkgs, ... }:
{
###########
# Systemd #
#######################################################################
  services = {
    displayManager = {
      sddm = {
        theme = "sugar-dark";
        autoNumlock = true;
        autoLogin.relogin = true;
      };
      ### --------------------------------------------------------- ###
      autoLogin.enable = true;
      autoLogin.user = "gabriel";
      defaultSession = "hyprland-uwsm";
    };
    flatpak.enable = true;
    snap.enable = true;
  };
  networking.extraHosts =
  ''
    192.168.122.10  rsx102-1.lan
    192.168.122.11  rsx102-2.lan
    192.168.122.12  rsx102-3.lan
  '';
########################################################################
}
