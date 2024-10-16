{ pkgs, ... }:
{
############
# Settings #
#######################################################################
  programs.fish.enable = true;
###########
# Package #
#######################################################################
  environment = {
    shells = with pkgs; [ fish ];
    variables.EDITOR = pkgs.ide;
    unixODBCDrivers = with pkgs; [
    ];
    systemPackages = with pkgs; [
      ### Utils --------------------------------------------------- ###
      fish
      fishPlugins.bobthefish
      fishPlugins.bass

      ### System -------------------------------------------------- ###
      nix-direnv
      multipath-tools

      ### Dev ----------------------------------------------------- ###
      android-tools
      pmbootstrap
      wireguard-tools

      ### Game ---------------------------------------------------- ###
    ];
  };
#######################################################################
}
