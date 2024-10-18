{ users, ... }:
{ config, pkgs, lib, ... }:
{
  # boot.loader.grub.useOSProber = true;
  # boot.loader.grub.extraEntries = ''
  #   menuentry "Windows 11" --class windows --class os {
  #     # Insert modules needed in order to access the iso-file
  #     # choose the right module for the partition-table-scheme the image lies on
  #     insmod part_gpt
  #
  #     # choose the right module for the filesystem the image lies on
  #     insmod ntfs
  #     insmod fat
  #     insmod ext2
  #
  #     # Insert module needed in order to find partition
  #     insmod search_fs_uuid
  #
  #
  #     # Set UUID of partition with the iso-image
  #     # and let grub2 find the partition
  #     # (save it's identifier to the variable $root)
  #     set uuid="3c541bbd-569e-40ed-84bd-fe3313a80e3c"
  #     search --no-floppy --set=root --fs-uuid $uuid
  #
  #     # Mount the iso image by addressing it with (partition)/path
  #     set img=/lib/libvirt/images/win11.img
  #     loopback loop ($root)$img
  #     set uuid="5849-0317"
  #     search --no-floppy --set=root --fs-uuid $uuid
  #
  #
  #     # boot (chain-load) the windows11-image using the bootmgfw.efi file located
  #     # on the Win11 .img
  #     # chainloader (loop,gpt1)/EFI/Microsoft/Boot/bootmgfw.efi
  #     linux16 /wimboot
  #     initrd16 \
  #       newc:bootmgr:/bootmgr \
  #       newc:bcd:/Boot/BCD \
  #       newc:boot.sdi:/boot.sdi \
  #       newc:boot.wim:/sources/boot.wim
  #   }
  #
  #   menuentry "Boot Windows from VHD" {
  #     insmod part_gpt
  #     insmod ntfs
  #     insmod vhd
  #
  #     set uuid="0F05EDBE49F0A952"
  #     search --no-floppy --fs-uuid --set=root $uuid
  #
  #     # chainloader /mnt/EFI/Microsoft/Boot/bootmgfw.efi
  #     #
  #     # set root=(hd0,gpt3)
  #     vhd /win11.vhd
  #
  #     uuid="6A43-705A"
  #     search --no-floppy --fs-uuid --set=root $uuid
  #     chainloader
  #
  #   }
  #
  #   menuentry "supergrub2" {
  #     set uuid="12CE-A600"
  #     search --no-floppy --fs-uuid --set=root $uuid
  #     chainloader /EFI/NixOS-boot-efi/supergrub2-classic-2.06s4-x86_64_efi-STANDALONE.EFI
  #   }
  # '';
  #      # ntldr (winloop,1)/bootmgr

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
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; }; # Force intel-media-driver
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ intel-vaapi-driver ];

  services.samba.shares.var = {
    path = "/var";
    browseable = "yes";
    writeable = "yes";
    "acl allow execute always" = true;
    "read only" = "no";
    "valid users" = "gabriel";
    "create mask" = "0644";
    "directory mask" = "0755";
    "force user" = "root";
    "force group" = "users";
  };

  # environment = {
  #   systemPackages = with pkgs; [
  #     libGL
  #     swtpm
  #   ];
  # };
  #
  # services.proxmox-ve.enable = true;
  # networking.interfaces.vmbr0 = {
  #   virtual = true;
  #   ipv4.addresses = [{
  #     address = "10.10.10.10";
  #     prefixLength = 16;
  #   }];
  # };
  #  networking = {
  #   firewall = {
  #     enable = true;
  #     extraCommands = ''
  #       iptables -t nat -A POSTROUTING -s "10.10.0.0/16" -o enp0s20f0u2 -j MASQUERADE
  #       iptables -t nat -A POSTROUTING -s "10.10.0.0/16" -o wlo1 -j MASQUERADE
  #     '';
  #   };
  # };

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
