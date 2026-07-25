{
  lib,
  pkgs,
  ...
}:
# The Lua configuration in config/nvim is symlinked by home/base.nix whether or
# not this module installs Neovim, so flipping `enable` is all that is needed to
# get an nvim that reads it.
{
  programs.neovim = {
    enable = false;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = true;

    extraPackages = with pkgs; [
      tree-sitter
    ];

    initLua = lib.mkAfter ''
      require("config")
      require("options")
      require("keymaps")
      require("treesitter")
      require("harpoons")
    '';
  };
}
