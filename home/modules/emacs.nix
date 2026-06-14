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
        vterm
        treesit-grammars.with-all-grammars
        pdf-tools
        notmuch
      ];
  };
}
