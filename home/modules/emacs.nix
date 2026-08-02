{ pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-git-pgtk;
    extraPackages =
      epkgs: with epkgs; [
        pdf-tools
        notmuch
        jinx
        (treesit-grammars.with-grammars (grammars: [
          grammars.tree-sitter-rust
        ]))
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
