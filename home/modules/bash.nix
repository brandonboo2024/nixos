{ ... }:

# Shell init for starship, yazi (`y`) and GPG_TTY comes from their own
# modules; do not repeat it in initExtra.
{
  programs.bash = {
    enable = true;
    shellAliases = {
      cat = "bat";
    };
  };
  programs.starship = {
    enable = true;
  };
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
  };
}
