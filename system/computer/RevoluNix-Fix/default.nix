{ users, ... }:
{ config, pkgs, lib, ... }:
{
  boot = {
    kernelParams = [
      "amd_iommu=on"
      "radeon.si_support=0"
      "amdgpu.si_support=1"
      "radeon.cik_support=0"
      "amdgpu.cik_support=1"
      "video=DisplayPort-1:1920x1080@75"
      "video=DisplayPort-2:1920x1080@75"
      "video=HDMI-A-0:1920x1080@75"
    ];

    initrd.kernelModules = [ "amdgpu" ];

    supportedFilesystems = [ "ntfs" ];
  };

  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  hardware.opengl = {
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      amdvlk
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  virtualisation.virtualMachines = {
    enable = true;
    username = users.primaryUser;
    sambaAccess.enable = true;

    machines = [
      {
        hardware = {
          cores = 4;
          memory = 12;
          disk = {
            size = 512;
            path = "/var/lib/libvirt/images";
          };
        };

        passthrough = {
          enable = true;
          pcies = [
            {
              lines = {
                bus = "01";
                slot = "00";
                functions = [
                  "0"
                  "1"
                  "2"
                  "3"
                ];
                ids = [
                  "10de:2184"
                  "10de:1aeb"
                  "10de:1aec"
                  "10de:1aed"
                ];
              };
              driver = ''nouveau'';
              blacklist = {
                driver = true;
              };
            }
          ];
        };
      }
    ];
  };
}
