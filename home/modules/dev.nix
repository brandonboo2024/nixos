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
    ripgrep
    fd
    fzf
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
    nil
    typescript-language-server
    vscode-css-languageserver
    # zls
    vscode-json-languageserver
    # jdt-language-server
    py
    rust-analyzer
    nodejs
    # tinymist
    # websocat
  ];

  languages = with pkgs; [
    zig
    typst
  ];

in
{
  home.packages = lsps ++ utilities ++ languages;
}
