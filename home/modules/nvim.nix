{lib,pkgs,inputs,config,...}:
{
  programs.neovim = lib.mkForce{
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
