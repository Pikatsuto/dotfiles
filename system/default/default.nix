{ hostname, users }:
{ config, pkgs, ... }:
{
###########
# Imports #
#######################################################################
  imports = [
    (import ./services.nix {
      primaryUser = users.primaryUser;
      hostname = hostname;
    })
    ./programs.nix
  ];
##########
# System #
#######################################################################
  security.sudo.wheelNeedsPassword = false;
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "fr_FR.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };
########
# User #
#######################################################################
  users.users = users.configs.system;
##################
# Virtualisation #
#######################################################################
  virtualisation = {
    docker.enable = true;
  };
#######################################################################
}
