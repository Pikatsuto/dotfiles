{ config, pkgs, ... }:
{
  boot = {
    kernelPackages = pkgs.linuxKernel.kernels.linux_6_1;

    initrd.availableKernelModules = [
      "ahci"
      "ohci_pci"
      "ehci_pci"
      "pata_atiixp"
      "xhci_pci"
      "firewire_ohci"
      "usb_storage"
      "usbhid"
      "sd_mod"
      "sr_mod"
    ];

    kernel.sysctl = { "vm.swappiness" = 1;};
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        gfxmodeEfi = "1920x1080x32";
        useOSProber = true;
      };
    };

    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];

    extraModprobeConfig = ''
      options hid_xpadneo quirks=B4:0E:DE:4B:06:94+32
      options iwlwifi bt_coex_active=0
      options iwlwifi swcrypto=1
      options iwlwifi power_save=0 d0i3_disable=0 uapsd_disable=0
    '';
    
    kernelModules = [
      "v4l2loopback"
    ];
  };
}
