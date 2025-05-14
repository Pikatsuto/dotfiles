{ pkgs, ... }:
let
  custonFonts = with pkgs; [
    noto-fonts-emoji
    nerdfonts
    terminus-nerdfont
    dejavu_fonts
    wine64Packages.fonts
    corefonts
  ];
in {
############
# Settings #
#######################################################################
  programs = {
    command-not-found.enable = false;
    dconf.enable = true;
    ## ------------------------------------------------------------- ##
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    ## ------------------------------------------------------------- ##
    corectrl.enable = true;
  };
#########
# Fonts #
#######################################################################
  nixpkgs.config.allowUnfreePredicate = custonFonts;
  fonts.packages = custonFonts;
###########
# Package #
#######################################################################
  environment = {
    systemPackages = with pkgs; [
      ### Utils --------------------------------------------------- ###
      git
      htop
      tree
      nano
      wget
      curl
      zip
      unzip
      killall
      bc
      pciutils

      ### System -------------------------------------------------- ###
      gdu
      xdotool
      coreutils
      v4l-utils

      ### Dev ----------------------------------------------------- ###
      ide
      man-pages
      man-pages-posix
    ];
  };
#######################################################################
}
