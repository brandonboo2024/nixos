{ ... }:

# GPG_TTY, the starship init and the yazi `y` wrapper are not set here: each
# of the modules below emits its own, and duplicating them in initExtra only
# meant a second, worse copy (a PATH lookup for starship instead of a store
# path, and a `y` that could recurse into its own alias).
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
