{ hostname, primaryUser }:
{ config, pkgs, ... }:
{
###########
# Systemd #
#######################################################################
  services = {
    displayManager = {
      sddm = {
        theme = "chili";
        autoNumlock = true;
        autoLogin.relogin = true;
      };
      ### --------------------------------------------------------- ###
      defaultSession = "hyprland";
    };
  };
########################################################################
}
