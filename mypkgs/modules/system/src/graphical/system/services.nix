{ hostname, ... }:
{ pkgs, lib, ... }:
{
###########
# Systemd #
#######################################################################
  services = {
    gnome.gnome-keyring.enable = true;
    languagetool.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
    openssh.enable = true;
    mpd.enable = true;
    fwupd.enable = true;
    ## ------------------------------------------------------------- ##
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    ## ------------------------------------------------------------- ##
    libinput = {
      enable = true;
      touchpad.tapping = true;
      touchpad.naturalScrolling = true;
    };
    ## ------------------------------------------------------------- ##
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
    ## ------------------------------------------------------------- ##
    xserver = {
      enable = true;
      ### --------------------------------------------------------- ###
      xkb = {
        layout = "fr";
        options = "eurosign:e,caps:escape";
      };
    };
  };
  # ------------------------------------------------------------------ #
  systemd = {
    services.wpa_supplicant = lib.mkForce {
      enable = true;
      description = "WPA supplicant";
      before = [ "network.target" ];
      wants = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        type = "dbus";
        alias = "dbus-fi.epitest.hostap.WPASupplicant.service";
        busName = "fi.epitest.hostap.WPASupplicant";
        ExecStart = let
          bin = "${pkgs.wpa_supplicant}/bin/wpa_supplicant";
          args = "-u -Dnl80211,wext -i wlan0";
          config = "-c /etc/wpa_supplicant/wpa_supplicant.conf";
        in "${bin} ${args} ${config}";
      };
    };
    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
  };
  # ------------------------------------------------------------------ #
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal
      ];
    };
  };
  # ------------------------------------------------------------------ #
  programs = {
    gamemode.enable = true;
    dconf.enable = true;
    xwayland.enable = true;
    ## -------------------------------------------------------------- ##
    hyprland = {
      enable = true;
      withUWSM  = true;
      xwayland.enable = true;
      package = pkgs.hyprland;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };
  };
  # ------------------------------------------------------------------ #
############
# Hardware #
########################################################################
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
  # ------------------------------------------------------------------ #
  hardware = {
    enableAllFirmware = true;
    xpadneo.enable = true;
    ## -------------------------------------------------------------- ##
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      input.General = {
        Name = hostname;
        ClassicBondedOnly = false;
        IdleTimeout = 600;
        ControllerMode = "dual";
        FastConnectable = "true";
      };
      ### ---------------------------------------------------------- ###
      settings = {
        Policy.AutoEnable = "true";
        General = {
          Enable = "Source,Sink,Media,Socket";
          ControllerMode = "dual";
          FastConnectable = "true";
        };
      };
    };
  };
  # ------------------------------------------------------------------ #
  networking = {
    hostName = hostname;
    wireless = {
      enable = true;
      userControlled.enable = true;
      extraConfig = ''
        ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=wheel
        ctrl_interface_group=wheel
        update_config=1
      '';
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [ 445 5357 ];
      allowedUDPPorts = [ 59100 3702 ];
      allowPing = true;
    };
  };
########################################################################
}
