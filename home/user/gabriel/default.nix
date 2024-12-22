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
      vesktop
      # (discord.override {
      #   withOpenASAR = true;
      #   withVencord = true;
      # })
      # xwaylandvideobridge

      ### Dev ----------------------------------------------------- ###
      btop
      kitty
      vscode
      drawio
      (writeShellApplication {
        name = "mssql-docker";
        runtimeInputs = [ docker ];
        text = ''
          cd ~/SYNC/Docker_Compose/MSSQL

          [ -z "$*" ] && \
            echo "mssql-docker start|stop" && exit 1
          [ "$*" == start ] && \
            docker compose up -d
          [ "$*" == stop ] && \
            docker compose stop
        '';
      })

      ### Games --------------------------------------------------- ###
      prismlauncher
      citra

      ### Misc ---------------------------------------------------- ###
      libreoffice
      onlyoffice-bin_latest
      qpdfview
      firefox
      viewnior
      nemo-with-extensions
      bitwarden-desktop
      pinta
      flowblade
      vlc

      ### Utils --------------------------------------------------- ###
      file-roller
      galculator
      # remmina
      gparted
      nextcloud-client
      ffmpeg
    ];
  };
#######################################################################
}
