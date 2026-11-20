{
  config,
  lib,
  pkgs,
  ...
}:

let
  # The nested config/ repository (cloned to ~/nixos/config, see README). Its
  # files are symlinked directly, so edits apply without a rebuild.
  dotfiles = "${config.home.homeDirectory}/nixos/config";

  # Link config/<subpath> into place; also passed to host profiles as a
  # module argument.
  linkDotfile = subpath: {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${subpath}";
    recursive = true;
  };

  # Linked whole, as ~/.config/<name>.
  configDirs = [
    "emacs"
    "fastfetch"
    "kanshi"
    "networkmanager-dmenu"
    "river"
    "scripts"
    "tmux"
  ];

  # Target path -> default source, linked per file so a host can mkForce its
  # own variant (see home/Prometheus.nix, home/Hephaestus.nix).
  configFiles = {
    "foot/common.ini" = "foot/common.ini";
    "foot/foot.ini" = "foot/foot.default.ini";
    "fuzzel/common.ini" = "fuzzel/common.ini";
    "fuzzel/fuzzel.ini" = "fuzzel/fuzzel.default.ini";
    "swayidle/config" = "swayidle/config.default";
  };

  # Linked per subdirectory so ~/.config/nvim stays writable for nvim itself.
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
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
  programs.git = {
    enable = true;
    lfs.enable = true;
    package = pkgs.gitFull;
    settings = {
      init.defaultBranch = "main";
      fetch.prune = true;
      diff.algorithm = "histogram";
      merge.conflictStyle = "zdiff3";
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

    # School and work repositories commit under the GitHub identity.
    includes =
      map
        (dir: {
          condition = "gitdir:${dir}";
          contents.user = {
            name = "brandonboo2024";
            email = "brandonboojunwei@gmail.com";
          };
        })
        [
          "~/102_school_work/"
          "~/103_school_proj/"
          "~/work/"
        ];
  };
  xdg.configFile =
    lib.genAttrs (configDirs ++ nvimDirs) linkDotfile
    // lib.mapAttrs (_target: source: linkDotfile source) configFiles;

  # Helper scripts are called by bare name. River adds them to PATH for the
  # graphical session; this covers interactive shells.
  home.sessionPath = [ "${config.xdg.configHome}/scripts" ];

  home.stateVersion = "25.11";
}
