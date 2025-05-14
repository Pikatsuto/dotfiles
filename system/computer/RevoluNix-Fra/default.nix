{ users, ... }:
{ config, pkgs, lib, ... }:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod_stable;
    kernelParams = [
      "net.ifnames=0"
      "amd_iommu=on"
      "video=eDP-2:2560x1600@165"
      "mem_sleep_default=deep"
      "amd_pstate=active"
      "amdgpu.ppfeaturemask=0xffffffff"
      "cpufreq.default_governor=powersave"
      "initcall_blacklist=cpufreq_gov_userspace_init,cpufreq_gov_performance_init"
      # "pcie_aspm=force"
      # "pcie_aspm.policy=powersupersave"
      "amdgpu.dcdebugmask=0x410"
      "amdgpu.abmlevel=0"
      "amdgpu.sg_display=0"
      "rtc_cmos.use_acpi_alarm=1"
    ];
    plymouth.enable = true;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 1234 ];
  };

  services = {
    fprintd.enable = true;
    ## -------------------------------------------------------------- ##
    upower.enable = true;
    power-profiles-daemon.enable = false;
    thermald.enable = true;
    tlp = {
      settings = {
        CPU_BOOST_ON_AC = 0;
        CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "powersave";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      };
    };
  };

  systemd.targets = {
    sleep.enable = lib.mkForce true;
    suspend.enable = lib.mkForce true;
    hibernate.enable = lib.mkForce true;
    hybrid-sleep.enable = lib.mkForce true;
  };

  environment.systemPackages = with pkgs; [
    # Thunderbolt
    thunderbolt

    # Framework
    framework-tool
    fw-ectool
    qmk_hid
    openrgb-with-all-plugins

    # Laptop
    powertop
    scowl

    lact
    sbctl
    clinfo
  ];

  environment.variables = {
    # DRI_PRIME = 1;
    NIXPKGS_ALLOW_UNFREE = 1;
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "radeonsi";
    QT-QUICK-BACKEND = 1;
    QSG-RHI-PREFER-SOFTWARE-RENDERER = 1;
    LD_PRELOAD = "";
    ROC_ENABLE_PRE_VEGA = "1";
  };

  # services.ollama.enable = true;

  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

  
  # services.proxmox-ve = {
  #   enable = true;
  #   ipAddress = "192.168.1.10";
  # };
  #
  # networking.bridges.vmbr0.interfaces = [ "eth0" ];
  # networking.useDHCP = false;
  # networking.interfaces.vmbr0.useDHCP = true;
  # networking.interfaces.wlan0.useDHCP = true;

  virtualisation.waydroid.enable = true;
  virtualisation.virtualMachines = {
    enable = true;
    username = users.primaryUser;
    sambaAccess.enable = true;

    machines = [
      {
        lookingGlass = true;
        hardware = {
          cores = 4;
          memory = 16;
          disk.enable = false;
        };
        passthrough = {
          enable = true;
          restartDm = false;
          smartAccessMemory = true;
          pcies = [
            {
              lines = {
                bus = "03";
                slot = "00";
                functions = [
                  {
                    fix = {
                      rom = false;
                      voidRom = true;
                      romBar = false;
                      rebar = {
                        enable = true;
                        resources = [
                          {
                            resource = 0;
                            resize = 13;
                          }
                          {
                            resource = 2;
                            resize = 3;
                          }
                        ];
                      };
                    };

                    function = "0";
                    vendor = "1002:7480";
                    drivers = [
                      "amdgpu"
                      "radeon"
                    ];
                    blacklist = {
                      vfioPriority = true;
                    };
                  }
                  {
                    function = "1";
                    vendor = "1002:ab30";
                    drivers = [
                      "snd_intel_hda"
                    ];
                    blacklist = {
                      vfioPriority = true;
                    };
                  }
                ];
              };
            }
            {
              disk = true;
              lines = {
                vmBus = "0a";
                bus = "04";
                slot = "00";
                functions = [
                  {
                    function = "0";
                    vendor = "15b7:5042";
                  }
                ];
              };
            }
          ];
        };
      }
    ];
  };
}
