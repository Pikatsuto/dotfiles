{ ... }:
{
#########
# Files #
#######################################################################
  home.file.electron-flags= {
    source = ./electron-flags.conf;
    target = ".config/electron-flags.conf";
  };
  home.file.code-flags= {
    source = ./code-flags.conf;
    target = ".config/code-flags.conf";
  };
  home.file.codium-flags= {
    source = ./codium-flags.conf;
    target = ".config/codium-flags.conf";
  };
#######################################################################
}
