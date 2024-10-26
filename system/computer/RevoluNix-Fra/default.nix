{ users, ... }:
{ config, pkgs, lib, ... }:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "net.ifnames=0"
      "amd_iommu=on"
      "radeon.si_support=0"
      "amdgpu.si_support=1"
      "video=eDP-2:2560x1600@165"
      "mem_sleep_default=deep"
    ];
    supportedFilesystems = [ "ntfs" ];

    loader.systemd-boot.enable = lib.mkForce false;
    loader.grub.enable = lib.mkForce false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    plymouth.enable = true;
  };

  systemd.tmpfiles.rules = 
  let
    rocmEnv = pkgs.symlinkJoin {
      name = "rocm-combined";
      paths = with pkgs.rocmPackages; [
        rocblas
        hipblas
        clr
      ];
    };
  in [
    "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
  ];

  hardware.opengl = {
	  enable = true;
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

  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = ["multi-user.target"];

  services.xserver.videoDrivers = [ "amdgpu" ];

  
  services = {
    blueman.enable = true;
    upower.enable = true;
    fprintd.enable = true;
    power-profiles-daemon.enable = false;
    thermald.enable = true;
    tlp = {
      settings = {
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
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

  environment.etc = {
    "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
      bluez_monitor.properties = {
        ["bluez5.enable-sbc-xq"] = true,
        ["bluez5.enable-msbc"] = true,
        ["bluez5.enable-hw-volume"] = true,
        ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
      }
    '';
  };

  environment.etc = {
    "libinput/local-overrides.quirks".text = ''
      [Keyboard]
      MatchUdevType=keyboard
      MatchName=Framework Laptop 16 Keyboard Module - ANSI Keyboard
      AttrKeyboardIntegration=internal
    '';
  };

  services.udev.extraRules = ''
     ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0012", ATTR{power/wakeup}="disabled", ATTR{driver/1-1.1.1.4/power/wakeup}="disabled"
     ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0014", ATTR{power/wakeup}="disabled", ATTR{driver/1-1.1.1.4/power/wakeup}="disabled"
  '';


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

  ];

  # ------------------------------------------------------------------ #
  hardware.sane.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.package = if (lib.versionOlder pkgs.bluez.version "5.76") then pkgs.unstable.bluez else pkgs.bluez;
  hardware.keyboard.qmk.enable = true;

  environment.variables = {
    NIXOS_OZONE_WL = "y";
  };

  virtualisation.virtualMachines = {
    enable = true;
    username = users.primaryUser;
    sambaAccess.enable = true;

    machines = [
      {
        hardware = {
          disk = {
            size = 512;
            path = "/home/gabriel/VM/DISK";
          };
        };
      }
    ];
  };
}
