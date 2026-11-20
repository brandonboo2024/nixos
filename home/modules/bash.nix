{ ... }:

# Shell init for starship, yazi (`y`), fzf and GPG_TTY comes from their own
# modules; do not repeat it in initExtra.
{
  programs.bash = {
    enable = true;
    shellAliases = {
      cat = "bat";
    };
  };
  # Ctrl-R history, Ctrl-T file picker, Alt-C directory jump, and completion.
  programs.fzf = {
    enable = true;
  };
  programs.starship = {
    enable = true;
  };
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
  };
}
