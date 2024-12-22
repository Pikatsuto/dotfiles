{ lib, builtins }:
let
  revoLib = lib.makeExtensible (self: let
    callLibs = file: import file { revoLib = self; };
  in {
    generateSystem = callLibs ./generate-system.nix;
  });
in revoLib