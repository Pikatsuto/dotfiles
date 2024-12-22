{ pkgs, ... }:
{
############
# Settings #
#######################################################################
  programs.fish.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    gamescopeSession.enable = true;
  };
###########
# Package #
#######################################################################
  environment = {
    shells = with pkgs; [ fish ];
    variables.EDITOR = pkgs.ide;
    # unixODBCDrivers = with pkgs; [
    # ];
    systemPackages = with pkgs; [
      ### Utils --------------------------------------------------- ###
      fish
      fishPlugins.bobthefish
      fishPlugins.bass

      ### System -------------------------------------------------- ###
      nix-direnv
      multipath-tools
      sddm-sugar-dark
      libsForQt5.qt5.qtgraphicaleffects

      ### Dev ----------------------------------------------------- ###
      android-tools
      pmbootstrap
      wireguard-tools

      ### Game ---------------------------------------------------- ###
    ];
  };
#######################################################################
}
