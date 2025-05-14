{ pkgs, ... }:
let
  custonFonts = with pkgs; [
    dina-font
    fira-code
    fira-code-symbols
    liberation_ttf
    mplus-outline-fonts.githubRelease
    noto-fonts-emoji
    nerdfonts
    terminus-nerdfont
    inconsolata-nerdfont
    dejavu_fonts
    hackgen-nf-font
    proggyfonts
    wine64Packages.fonts
    corefonts
    vistafonts
    material-icons
    material-design-icons
    cascadia-code
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
    nix-ld.enable = true;
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
      modemmanager
      gdu
      xdotool
      ldacbt
      coreutils
      v4l-utils
      bluez-tools
      bluez-alsa
      bluetuith
      hyprpolkitagent
      hyprpaper
      hypridle
      hyprcursor
      aquamarine

      ### Dev ----------------------------------------------------- ###
      ide
      man-pages
      man-pages-posix
      appimage-run
      glibc

      ### Game ---------------------------------------------------- ###
    ];
  };
#######################################################################
}
