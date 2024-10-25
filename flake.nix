{
###########
# Imports #
#######################################################################
  description = "Pikatsuto dotfiles";
  # ----------------------------------------------------------------- #
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cache.saumon.network/proxmox-nixos"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "proxmox-nixos:nveXDuVVhFDRFx8Dn19f1WDEaNRJjPrF2CPD2D+m1ys="
    ];
  };
  # ----------------------------------------------------------------- #
  inputs = {
    nixpkgs.url = "github:RevoluNix/revolunixpkgs/testing";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
#############
# Variables #
#######################################################################
  outputs = {
    nixos-hardware,
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";
    hostname = "RevoluNix";
    pkgs = nixpkgs.proxmoxPkgs;
    purepkgs = nixpkgs.purepkgs;

    users = rec {
      primaryUser = "gabriel";
      allUsers = [
        primaryUser
      ];
      descriptions = {
        "${primaryUser}" = "Gabriel Guillou";
      };


      configs = {
        home = hostname: builtins.listToAttrs
          (nixpkgs.lib.forEach allUsers (username: {
            name = username;
            value = (import ./home {
              inherit username hostname;
              externalImports = [
                nixpkgs.configsImports.revolunixos.base.graphical.home
              ];
            });
          }));

        system = builtins.listToAttrs
          (nixpkgs.lib.forEach allUsers (username: {
            name = username;
            value = {
              description = descriptions."${username}";
              isNormalUser = true;
              shell = pkgs.fish;
              extraGroups = [
                "wheel"
                "libvirtd"
                "docker"
              ];
              initialPassword = "admin";
            };
          }));
      };
    };

    applyAttrNames = builtins.mapAttrs (name: f: f name);

    computers = applyAttrNames {
      "${hostname}-Fix" = self: {
        hostname = "${self}";
        modules = [];
      };
      "${hostname}-Lap" = self: {
        hostname = "${self}";
        modules = [
          nixos-hardware.nixosModules.asus-battery
          nixos-hardware.nixosModules.common-cpu-intel
          nixos-hardware.nixosModules.common-pc
          nixos-hardware.nixosModules.common-pc-ssd
        ];
      };
    };
    ## ------------------------------------------------------------- ##
    defaultModules = [
      nixpkgs.nixosModules.virtualMachines
    ];
##########
# Config #
#######################################################################
  in
  {
    nixosConfigurations = (purepkgs.lib.genAttrs
    (builtins.attrNames computers)
    (name: purepkgs.lib.nixosSystem {
      specialArgs = {
        inherit pkgs;
      };
      inherit system;

      modules = let
        hostname = name;
      in defaultModules
        ++ nixpkgs.defaultModules
        ++ computers.${name}.modules
        ++ [

          (import ./system {
            inherit hostname users;
            externalImports = [
              nixpkgs.configsImports.revolunixos.base.graphical.system
            ];
          })

          ./hardware/${hostname}.nix

          home-manager.nixosModules.home-manager {home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup18";
            users = (users.configs.home hostname);
          };}
        ];
    }));
  };
#######################################################################
}
