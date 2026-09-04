{ pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-git-pgtk;
    extraPackages =
      epkgs: with epkgs; [
        auctex
        auctex-latexmk
        notmuch
        jinx
      ];
  };

  home.packages = [ pkgs.hunspellDicts.en_US ];

  # The River profile binds this service to river-session.target. Avoid the
  # module's default login-session target so the daemon cannot outlive River.
  services.emacs = {
    enable = true;
    startWithUserSession = false;
  };
}
