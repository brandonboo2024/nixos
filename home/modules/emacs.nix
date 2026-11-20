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
        zmq
      ];
  };

  home.packages = [ pkgs.hunspellDicts.en_US ];

  # Started by home/profiles/river.nix instead, so it does not outlive River.
  services.emacs = {
    enable = true;
    startWithUserSession = false;
  };
}
