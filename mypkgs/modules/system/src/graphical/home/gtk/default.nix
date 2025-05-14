{ pkgs, ... }:
{
##########
# Config #
#######################################################################
  gtk = {
    enable = true;

    theme = {
      name = "Fluent-round-Dark-compact";
      package = (pkgs.fluent-gtk-theme.override {
        themeVariants = ["default"];
        colorVariants = ["dark"];
        sizeVariants = ["compact"];
        tweaks = ["round"];
      });
    };

    cursorTheme = {
      name = "capitaine-cursors";
      package = pkgs.capitaine-cursors;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };
#######################################################################
}
