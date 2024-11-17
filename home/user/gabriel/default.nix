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
    sessionVariables = {
      EDITOR = pkgs.ide;
    };
    ## ------------------------------------------------------------- ##
    packages = with pkgs; [
      ### Settings ------------------------------------------------ ###
      xwaylandvideobridge

      ### Volume -------------------------------------------------- ###
      rofi-beats
      pwvucontrol

      ### Messaging ----------------------------------------------- ###
      (pkgs.vesktop)

      ### Dev ----------------------------------------------------- ###
      btop
      kitty
      vscode

      ### Games --------------------------------------------------- ###
      prismlauncher
      citra

      ### Misc ---------------------------------------------------- ###
      libreoffice
      onlyoffice-bin_latest
      qpdfview
      firefox
      viewnior
      cinnamon.nemo-with-extensions

      ### Utils --------------------------------------------------- ###
      gnome.file-roller
      galculator
      remmina
      nextcloud-client
    ];
  };
#######################################################################
}
