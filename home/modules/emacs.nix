{
  lib,
  config,
  pkgs,
  ...
}:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-git-pgtk;
    extraPackages =
      epkgs: with epkgs; [
        pdf-tools
        notmuch
      ];
  };
}
