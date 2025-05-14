###########
# Imports #
#######################################################################
inputs @ {
  nixpkgs,
  unstable,
  home-manager,
  flox,
  ...
}: let
#############
# Variables #
#######################################################################
  defaultSystems = [
    "aarch64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
    "x86_64-linux"
  ];

  system = "x86_64-linux";
  pkgsSettings = {
    inherit system;
    config.allowUnfree = true;
  };

#############
# Functions #
#######################################################################
  forAllSystems = function:
    nixpkgs.lib.genAttrs defaultSystems
    (system: function nixpkgs.legacyPackages.${system});

  packages = forAllSystems (pkgs:
    let scope = pkgs.lib.makeScope
      pkgs.newScope (self: { inherit inputs; });

    in pkgs.lib.filesystem.packagesFromDirectoryRecursive {
      inherit (scope) callPackage;
      directory = ./pkgs;
    });

  appendPkgsWithPkgs = new-element-path: imports-object:
    imports-object.pkgs // { "${baseNameOf new-element-path}" =
      (import new-element-path imports-object);};

###########
# Overlay #
#######################################################################
  pkgsWine = (import (fetchTree {
    type = "github";
    owner = "nixos";
    repo = "nixpkgs";
    rev = "21808d22b1cda1898b71cf1a1beb524a97add2c4";
  }) {
    system = system;
    config.allowUnfree = true;
  });

  overlayModules = {
    nixosModules = nixpkgs.nixosModules // {
      virtualMachines = import ./modules/virtual-machine;
      home-manager = home-manager.nixosModules.home-manager;
    };

    systemTemplate = (import ./modules/system {
      inherit home-manager;
      nixpkgs = revoluNixPkgs;
    });

    defaultModules = [
    ];
  };

  overlayPkgs = {
    unstable = import unstable pkgsSettings;
    stable = import nixpkgs pkgsSettings;
    purepkgs = nixpkgs;
    inherit
      pkgsWine
      flox
    ;
  };

  revoluNixOverlays = [
    (_: _: (packages."${system}"))
    (_: _: overlayModules)
    (_: _: overlayPkgs)
  ];

  revoluNixPkgs = import nixpkgs (pkgsSettings // {
    overlays = revoluNixOverlays;
  });

###########
# Outputs #
#######################################################################
  in revoluNixPkgs
#######################################################################
