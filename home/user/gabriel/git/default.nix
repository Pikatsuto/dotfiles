{ ... }:
{
##########
# Config #
#######################################################################
  programs.git = {
    enable = true;
    userName = "Pikatsuto";
    userEmail = "pikatsuto@gmail.com";

    extraConfig = {
      url.init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };

    ignores = [
      # C commons
      "*.gc??"
      "vgcore.*"
      # Python
      "venv"
      # Locked Files
      "*~"
      # Mac folder
      ".DS_Store"
      # Direnv
      ".direnv"
      ".envrc"
      # IDE Folders
      ".idea"
      ".vscode"
      ".vs"
    ];
  };
#######################################################################
}
