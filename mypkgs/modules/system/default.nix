{ nixpkgs, home-manager }: {
  cli = {
    home = ./src/cli/home;
    system = ./src/cli/system;
  };
  graphical = {
    home = ./src/graphical/home;
    system = ./src/graphical/system;
  };
}
