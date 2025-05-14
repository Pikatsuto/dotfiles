{ hostname, ... }:
{ ... }:
{
###########
# Imports #
#######################################################################
  imports = [
    (import ./services.nix {
      inherit hostname;
    })
    ./programs.nix
    ./issue
    ./polkit
    ./boot.nix
  ];
##########
# System #
#######################################################################
  system = {
    copySystemConfiguration = false;
    stateVersion = "24.11";
  };
  # ----------------------------------------------------------------- #
  environment.variables = {
    NIXOS_OZONE_WL = "y";
  };
  nixpkgs.config.chromium.commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";
  # ----------------------------------------------------------------- #
  documentation.dev.enable = true;
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    ## ------------------------------------------------------------- ##
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
      keep-outputs = true;
      keep-derivations = true;
      auto-optimise-store = true;
      warn-dirty = false;
    };
    ## ------------------------------------------------------------- ##
    optimise.automatic = true;
  };
  # ----------------------------------------------------------------- #
  security.sudo.wheelNeedsPassword = false;
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "fr_FR.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };
  # ----------------------------------------------------------------- #
  nixpkgs.config.allowUnfree = true;
#######################################################################
}
