{
###########
# Imports #
#######################################################################
  description = "Pikatsuto dotfiles";
  # ----------------------------------------------------------------- #
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cache.flox.dev"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
    ];
  };
  # ----------------------------------------------------------------- #
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flox.url = "github:flox/flox/v1.3.17";
    nix-snapd.url = "github:nix-community/nix-snapd";
    nix-snapd.inputs.nixpkgs.follows = "nixpkgs";
  };
#############
# Variables #
#######################################################################
  outputs = {
    nixos-hardware,
    nixpkgs,
    home-manager,
    unstable,
    flox,
    nix-snapd,
    ...
  }: let
    system = "x86_64-linux";
    hostname = "RevoluNix";
    pkgs = (import ./mypkgs {
      inherit
        nixpkgs
        unstable
        home-manager
        flox
      ;
    });
    purepkgs = pkgs.purepkgs;

    usersInfo = rec {
      primaryUser = {
        isNormalUser = true;
        name = "gabriel";
        shell = pkgs.fish;
        extraGroups = [
          "wheel"
          "libvirtd"
          "docker"
        ];
        initialPassword = "admin";
      };
      allUsers = [
        primaryUser
      ];
    };

    users = rec {
      primaryUser = "gabriel";
      allUsers = [
        primaryUser
      ];

      configs = {
        home = hostname: builtins.listToAttrs
          (pkgs.lib.forEach allUsers (username: {
            name = username;
            value = (import ./home {
              inherit username hostname;
              externalImports = [
                pkgs.systemTemplate.graphical.home
              ];
            });
          }));

        system = builtins.listToAttrs
          (pkgs.lib.forEach allUsers (username: {
            name = username;
            value = {
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
      "${hostname}-Fra" = self: {
        hostname = "${self}";
        modules = [
          nixos-hardware.nixosModules.framework-16-7040-amd
        ];
      };
    };
    ## ------------------------------------------------------------- ##
    defaultModules = [
      pkgs.nixosModules.virtualMachines
      nix-snapd.nixosModules.default
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
        ++ pkgs.defaultModules
        ++ computers.${name}.modules
        ++ [

          (import ./system {
            inherit hostname users;
            externalImports = [
              pkgs.systemTemplate.graphical.system
            ];
          })

          ./hardware/${hostname}.nix

          home-manager.nixosModules.home-manager {home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup39";
            users = (users.configs.home hostname);
          };}
        ];
    }));
  };
#######################################################################
}
