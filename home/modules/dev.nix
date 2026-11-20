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
  # TeX Live bundles latexminted 0.6.0, which does not support Python 3.14.
  minted = (pkgs.texlive.override { python3 = pkgs.python313; }).pkgs.minted;

  utilities = with pkgs; [
    ripgrep
    fd
    shellcheck
    nixfmt
    (texliveSmall.withPackages (ps: [
      ps.scheme-basic
      ps.ulem
      ps.amsmath
      ps.wrapfig
      ps.capt-of
      ps.dvipng
      ps.dvisvgm
      ps.latexmk
      ps.chktex
      minted
    ]))
    # mysql
    mycli
  ];
  lsps = with pkgs; [
    # Language Servers
    # nixpkgs-fmt
    # lua-language-server
    nixd
    # typescript-language-server
    # vscode-css-languageserver
    zls
    # vscode-json-languageserver
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
    rustc
    cargo
    clippy
  ];

  ops = with pkgs; [
    minikube
    (wrapHelm kubernetes-helm {
      plugins = with pkgs.kubernetes-helmPlugins; [
        helm-secrets
        helm-diff
        helm-s3
        helm-git
      ];
    })
  ];
in
{
  # k8s removed for now
  home.packages = lsps ++ utilities ++ languages;

  # programs.vscodium = {
  #   enable = true;
  #   profiles.default.extensions = with pkgs.vscode-extensions; [
  #     llvm-vs-code-extensions.vscode-clangd
  #     ms-vscode.cpptools
  #     ms-vscode.cmake-tools
  #     ms-vscode.makefile-tools
  #     twxs.cmake
  #     vadimcn.vscode-lldb
  #   ];
  # };
}
