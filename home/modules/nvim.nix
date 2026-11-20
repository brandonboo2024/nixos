{
  lib,
  pkgs,
  ...
}:
# Disabled. home/base.nix links config/nvim regardless, so flipping `enable`
# is all it takes to bring it back.
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
