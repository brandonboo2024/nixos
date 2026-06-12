{config, pkgs, pkgsStable,inputs, ...}:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    # nvim = "nvim";  #add laptop specific configs here
  };
in
{
  imports = [
    ../base.nix
  ];
  # symlinking configs not done by nix language
  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

  home.username="Daedalus";
  home.homeDirectory = "/home/Daedalus";
  # home.username="boo";
  # home.homeDirectory = "/home/boo";
  # home.stateVersion = "25.11";
}
