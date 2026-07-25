{
  config,
  lib,
  pkgs,
  pkgsStable,
  inputs,
  ...
}:

let
  # Application config lives in the nested config/ dotfiles repository and is
  # symlinked out of the store, so edits there take effect without a rebuild.
  # See the README: that repository must be cloned to ~/nixos/config.
  dotfiles = "${config.home.homeDirectory}/nixos/config";

  # Link config/<subpath> to ~/.config/<subpath>. Exposed to the per-host
  # profiles so they can add machine-specific links.
  linkDotfile = subpath: {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${subpath}";
    recursive = true;
  };

  # Linked whole, as ~/.config/<name>.
  configDirs = [
    "emacs"
    "fastfetch"
    "kanshi"
    "mako"
    "river"
    "rofi"
    "swayidle"
    "tmux"
    "zathura"
  ];

  # Linked file by file rather than as a directory, so that a machine can
  # point one of them at a variant in the same directory (see
  # home/Prometheus.nix). Overlaying a single file into a symlinked directory
  # is not possible; overriding one of these entries is.
  configFiles = [
    "foot/foot.ini"
    "fuzzel/fuzzel.ini"
  ];

  # Neovim is linked one subdirectory at a time rather than as a whole, so
  # that ~/.config/nvim itself stays writable for anything nvim generates.
  nvimDirs = [
    "nvim/after"
    "nvim/lua"
    "nvim/plugin"
  ];
in
{
  _module.args = { inherit linkDotfile; };

  imports = [
    ./modules/packages.nix
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
  xdg.configFile = lib.genAttrs (configDirs ++ configFiles ++ nvimDirs) linkDotfile;

  home.stateVersion = "25.11";
}
