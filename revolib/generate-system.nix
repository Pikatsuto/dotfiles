{ revoLib, lib, builtins }:
rec {
  generateUsers = users: with users; {
      configs = {
        home = hostname: builtins.listToAttrs
          (nixpkgs.lib.forEach allUsers (user: {
            name = user.username;
            value = (import ./home {
              inherit hostname;
              username = user.username;
              externalImports = [
                nixpkgs.configsImports.revolunixos.base.graphical.home
              ];
            });
          }));

        system = builtins.listToAttrs
          (nixpkgs.lib.forEach allUsers (user: {
            name = user.username;
            value = with user; {
              inherit
                username
                shell
                extraGroups
                initialPassword
                isNormalUser;
            };
          }));
      };
    };
}