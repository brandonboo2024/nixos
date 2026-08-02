{ pkgs, ... }:

let
  py = pkgs.python313.withPackages (
    ps: with ps; [
      python-lsp-server
      (python-lsp-black.overridePythonAttrs (_: {
        doCheck = false;
      }))
      pyflakes
      pycodestyle
      black
      scipy
    ]
  );
  utilities = with pkgs; [
    direnv
    ripgrep
    fd
    fzf
    shellcheck
    nixfmt
    (texliveSmall.withPackages (ps: [
      ps.scheme-basic
      ps.ulem
      ps.amsmath
      ps.dvipng
      ps.dvisvgm
    ]))
  ];
  lsps = with pkgs; [
    # Language Servers
    # nixpkgs-fmt
    lua-language-server
    nixd
    typescript-language-server
    vscode-css-languageserver
    zls
    vscode-json-languageserver
    # jdt-language-server
    py
    rust-analyzer
    nodejs
    # tinymist
    # websocat
  ];

  languages = with pkgs; [
    guile
    zig
    typst
    # rust-analyzer above cannot resolve a sysroot without these, so it was
    # installed but non-functional.
    rustc
    cargo
    clippy
  ];

in
{
  home.packages = lsps ++ utilities ++ languages;
}
