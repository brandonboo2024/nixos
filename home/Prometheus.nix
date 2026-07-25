{ pkgs, ... }:

# Yoga laptop. Username, home directory and the shared dotfile symlinks come
# from home/base.nix and the flake; only Prometheus-specific settings go here.
# To link an extra config directory on this machine only:
#   xdg.configFile."foo" = linkDotfile "foo";   # helper lives in base.nix
{
  imports = [
    ./base.nix
    ./modules/obs.nix
  ];

  home.packages = with pkgs; [
    zoom-us
  ];
}
