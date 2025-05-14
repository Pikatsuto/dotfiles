{ username, ... }:
{ pkgs, ... }:
{
###########
# Imports #
#######################################################################
  imports = [
    ## Config ------------------------------------------------------ ##
    ./fish
    ./extraFiles
    ./git
    ./background
  
    ## Apps -------------------------------------------------------- ##
    ./programs.nix

    ## System ------------------------------------------------------ ##
    ./hyprland/keybind
    ./hyprland/userConfig

    ## Other-------------------------------------------------------- ##
  ];
############
# Packages #
#######################################################################
  home = {
    sessionPath = [
      "/home/${username}/.local/bin/"
    ];
    ## ------------------------------------------------------------- ##
    sessionVariables = {
      EDITOR = pkgs.ide;
    };
    ## ------------------------------------------------------------- ##
    packages = with pkgs; [
      ### Settings ------------------------------------------------ ###

      ### Volume -------------------------------------------------- ###
      rofi-beats
      pwvucontrol

      ### Messaging ----------------------------------------------- ###
      # (discord.override {
      #   withOpenASAR = true;
      #   withVencord = true;
      # })

      ### Dev ----------------------------------------------------- ###
      btop
      kitty
      vscode
      drawio

      ### Games --------------------------------------------------- ###
      prismlauncher

      ### Misc ---------------------------------------------------- ###
      libreoffice
      onlyoffice-bin_latest
      qpdfview
      viewnior
      nautilus
      zen-browser
      bitwarden-desktop
      pinta
      flowblade
      vlc

      ### Utils --------------------------------------------------- ###
      file-roller
      gnome-calculator
      remmina
      gparted
      nextcloud-client
      ffmpeg
      wineWowPackages.waylandFull
    ];
  };
#######################################################################
}
