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
      defaultSession = "hyprland";
    };
  };
########################################################################
}
