{ ... }:
{
#########
# Files #
#######################################################################
  home.file.hyprlandMonitor = {
    source = ./hyprland.conf;
    target = ".config/hypr/monitor.conf";
    recursive = false;
  };
#######################################################################
}
