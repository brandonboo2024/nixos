{
  config,
  pkgs,
  pkgsStable,
  inputs,
  ...
}:

let
  dotfiles = "${config.home.homeDirectory}/nixos/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    rofi = "rofi";
    nvim = "nvim"; # uncomment after adding your own nvim config
    fastfetch = "fastfetch";
    tmux = "tmux";
    zathura = "zathura";
    emacs = "emacs";
    foot = "foot";
    river = "river";
    kanshi = "kanshi";
    fuzzel = "fuzzel";
    mako = "mako";
    swayidle = "swayidle";
  };
in
{
  imports = [
    ./modules/HomePackages.nix
    ./modules/nvim.nix
    ./modules/firefox.nix
    ./modules/bash.nix
    ./modules/sioyek.nix
    ./modules/emacs.nix
    ./modules/dev.nix
    ./modules/mail.nix
  ];
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    settings = {
      user = {
        name = "jwboo";
        email = "jwboo@posteo.com";
      };
      sendemail = {
        from = "jwboo@posteo.com";
        sendmailCommand = "${pkgs.msmtp}/bin/msmtp --read-envelope-from";
        confirm = "auto";
        suppressFrom = true;
        envelopeSender = "auto";
        chainReplyto = false;
      };
    };

    includes = [
      {
        condition = "gitdir:~/102_school_proj/";
        contents = {
          user = {
            name = "brandonboo2024";
            email = "brandonboojunwei@gmail.com";
          };
        };
      }
      {
        condition = "gitdir:~/work/";
        contents = {
          user = {
            name = "brandonboo2024";
            email = "brandonboojunwei@gmail.com";
          };
        };
      }
    ];
  };
  xdg.configFile =
    (builtins.mapAttrs (name: subpath: {
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
