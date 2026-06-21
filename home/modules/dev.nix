{
  lib,
  config,
  pkgs,
  ...
}:

let
  py = pkgs.python313.withPackages (
    ps: with ps; [
      python-lsp-server
      python-lsp-black
      pyflakes
      pycodestyle
      black
      scipy
    ]
  );
  utilities = with pkgs; [
    ripgrep
    fd
    fzf
    (texlive.combine {
      inherit (pkgs.texlive)
        scheme-basic
        ulem
        amsmath
        dvipng
        dvisvgm
        ;
    })
  ];
  lsps = with pkgs; [
    # Language Servers
    nixpkgs-fmt
    lua-language-server
    nil
    typescript-language-server
    vscode-css-languageserver
    # zls
    vscode-json-languageserver
    # jdt-language-server
    py
    rust-analyzer
    nodejs
    tinymist
    websocat
  ];

  languages = with pkgs; [
    zig
  ];

in
{
  home.packages = lib.unique (lsps ++ utilities ++ languages);
}
