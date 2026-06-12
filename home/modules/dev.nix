{lib, config, pkgs, ...}:

let
    py = pkgs.python313.withPackages(ps: with ps;[
        python-lsp-server
        python-lsp-black
        pyflakes
        pycodestyle
        black
        scipy
    ]);
    utilities = with pkgs; [
      ripgrep
      fd
      fzf
    ];

    lsps = with pkgs;[
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

    treesitter = with pkgs; [
      (tree-sitter.withPlugins (grammars: with grammars; [
      tree-sitter-c
      tree-sitter-cpp
      tree-sitter-rust
      tree-sitter-python
      tree-sitter-javascript
      ]))
    ];
in
{
  home.packages = lib.unique (
    lsps 
    ++ utilities
    ++ treesitter
  );
}
