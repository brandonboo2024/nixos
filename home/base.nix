{
  config,
  lib,
  pkgs,
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
    "river"
    "scripts"
    "tmux"
  ];

  # Target path -> portable default source. These are linked file by file so a
  # machine can select a profile without turning the target directory into a
  # symlink back into the dotfiles repository. See home/Prometheus.nix and
  # home/Hephaestus.nix for the machine-specific overrides.
  configFiles = {
    "foot/foot.ini" = "foot/foot.default.ini";
    "fuzzel/fuzzel.ini" = "fuzzel/fuzzel.default.ini";
    "swayidle/config" = "swayidle/config.default";
  };

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
    ./modules/direnv.nix
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
    lib.genAttrs (configDirs ++ nvimDirs) linkDotfile
    // lib.mapAttrs (_target: source: linkDotfile source) configFiles;

  # The helper scripts are called by bare name from tmux, River and each
  # other. River puts them on PATH itself for the graphical session; this
  # covers interactive shells.
  home.sessionPath = [ "${config.xdg.configHome}/scripts" ];

  home.stateVersion = "25.11";
}
