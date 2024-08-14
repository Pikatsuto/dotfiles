{ hostname, primaryUser }:
{ config, pkgs, ... }:
{
###########
# Systemd #
#######################################################################
  services = {
    displayManager = {
      sddm = {
        autoNumlock = true;
        autoLogin.relogin = true;
      };
      ### --------------------------------------------------------- ###
      defaultSession = "hyprland";
      autoLogin.enable = true;
      autoLogin.user = primaryUser;
    };
    fprintd = {
      enable = true;
      package = pkgs.fprintd-ft9201;
    };
    udev.extraRules = ''
      # FocalTech Systems Co., Ltd Fingerprint
      SUBSYSTEM=="usb", ATTRS{idVendor}=="2808", ATTRS{idProduct}=="93a9", ATTRS{dev}=="*", TEST=="power/control", ATTR{power/control}="auto", MODE="0660", GROUP="plugdev"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="2808", ATTRS{idProduct}=="93a9", ENV{LIBFPRINT_DRIVER}="FocalTech Systems Co., Ltd Fingerprint"
    '';
  };
########################################################################
}
