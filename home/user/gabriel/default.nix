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

      ### Volume -------------------------------------------------- ###
      rofi-beats
      pwvucontrol

      ### Messaging ----------------------------------------------- ###
      (pkgs.unstable.vesktop) 

      ### Dev ----------------------------------------------------- ###
      btop
      kitty
      jetbrains.phpstorm
      jetbrains-toolbox
      vscode
      nodejs
      (pkgs.unstable.termius)

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
    ];
  };
#######################################################################
}
