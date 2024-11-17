{ pkgs, ... }:
{
#########
# Files #
#######################################################################
  home.file.easyeffects_configs = {
    source = ./src;
    target = ".config/easyeffects";
    recursive = true;
  };
#######################################################################
}
