{ pkgs, ... }:
{
#########
# Files #
#######################################################################
  home.file.libreoffice_configs = {
    source = ./src;
    target = ".config/libreoffice_tmp";
    recursive = true;
  };
#######################################################################
}
