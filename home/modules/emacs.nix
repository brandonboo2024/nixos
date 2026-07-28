{ pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-git-pgtk;
    extraPackages =
      epkgs: with epkgs; [
        pdf-tools
        notmuch
        (treesit-grammars.with-grammars (grammars: [
          grammars.tree-sitter-rust
        ]))
      ];
  };
}
