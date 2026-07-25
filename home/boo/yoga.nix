{config, pkgs, pkgsStable,inputs, ...}:

let
  dotfiles = "${config.home.homeDirectory}/nixos/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    # nvim = "nvim";  #add laptop specific configs here
  };
in
{
  imports = [
    ../base.nix
    ../modules/obs.nix
  ];
  # symlinking configs not done by nix language
  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

  home.username="Prometheus";
  home.homeDirectory = "/home/Prometheus";

	home.packages = with pkgs;[
    zoom-us
	];

  # home.username="boo";
  # home.homeDirectory = "/home/boo";
  # home.stateVersion = "25.11";
}
