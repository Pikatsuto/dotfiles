{ ... }:
{
#########
# Files #
#######################################################################
  home.file.writableConfigs = {
    source = ./cpwrconf;
    target = ".local/bin/cpwrconf";
    recursive = false;
  };
#######################################################################
}
