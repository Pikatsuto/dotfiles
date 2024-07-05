{ users, ... }:
{ config, pkgs, lib, ... }:
{
  networking.extraHosts = ''
    10.193.48.101 worktogether.dev
  '';
  
  boot.kernelParams = [ "i915.force_probe=00:02:0" ];
  
  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; }; # Force intel-media-driver
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ intel-vaapi-driver ];

  virtualisation.virtualMachines = {
    enable = true;
    username = users.primaryUser;
    sambaAccess.enable = true;

    machines = [
      {
        hardware = {
          disk = {
            size = 512;
            path = "/var/lib/libvirt/images";
          };
        };
      }
    ];
  };
}
