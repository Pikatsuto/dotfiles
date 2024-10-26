{ hostname, primaryUser }:
{ config, pkgs, ... }:
{
###########
# Systemd #
#######################################################################
  services = {
    displayManager = {
      sddm = {
        autoNumlock = true;
        autoLogin.relogin = true;
      };
      ### --------------------------------------------------------- ###
      defaultSession = "hyprland";
    };
  };
########################################################################
}
