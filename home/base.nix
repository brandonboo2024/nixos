{config, pkgs, pkgsStable, inputs, ...}:

let
  dotfiles = "${config.home.homeDirectory}/nixos/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    rofi = "rofi";
    mango = "mango";
    nvim = "nvim";  #uncomment after adding your own nvim config
    fastfetch = "fastfetch";
		tmux = "tmux";
		zathura = "zathura";
    emacs = "emacs";
  };
in
{
  imports = [
    ./modules/mangowc.nix
    ./modules/HomePackages.nix
    ./modules/ui.nix
    ./modules/dms.nix
    ./modules/kitty.nix
    ./modules/yazi.nix
    ./modules/nvim.nix
    ./modules/firefox.nix
    ./modules/bash.nix
    ./modules/sioyek.nix
    ./modules/emacs.nix
    ./modules/dev.nix
  ];
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    settings = {
      user.name = "brandonboo2024";
      user.email = "brandonboojunwei@gmail.com";
      sendemail.smtpServer = "smtp.gmail.com";
      sendemail.smtpUser = "brandonboojunwei@gmail.com";
      sendemail.smtpencryption = "ssl";
      sendemail.smtpserverport = "465";
      sendemail.smtpAuth = "OAUTHBEARER";
      sendemail.from = "Brandon Boo brandonboojunwei@gmail.com";
       
      "credential \"smtp://smtp.gmail.com:465\"" = {
        helper = [
          ""
          "gmail"
        ];
      };

    };
  };
  xdg.configFile = (builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) (builtins.removeAttrs configs [ "nvim" ]))
  // {
    # Keep Neovim managed as directories so the Lua config stays portable.
    "nvim/lua" = {
      source = create_symlink "${dotfiles}/nvim/lua";
      recursive = true;
    };
    "nvim/plugin" = {
        source = create_symlink "${dotfiles}/nvim/plugin";
        recursive = true;
    };
    "nvim/after" = {
        source = create_symlink "${dotfiles}/nvim/after";
        recursive = true;
    };
  };
  # symlinking configs not done by nix language
  

  home.stateVersion = "25.11";
}
