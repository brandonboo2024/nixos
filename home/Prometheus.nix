{
  lib,
  pkgs,
  linkDotfile,
  ...
}:

# Yoga laptop. Username, home directory and the shared dotfile symlinks come
# from home/base.nix and the flake; only Prometheus-specific settings go here.
{
  imports = [
    ./base.nix
    ./profiles/river.nix
    ./modules/obs.nix
  ];

  # The 3200x2000 panel runs at scale 1, so UI dimensions are in physical
  # pixels and can be tuned independently from every other machine. Point
  # these configs at this machine's variants; river reads its own values from
  # config/river/hosts/Prometheus.sh.
  xdg.configFile."foot/foot.ini" = lib.mkForce (linkDotfile "foot/foot.Prometheus.ini");
  xdg.configFile."fuzzel/fuzzel.ini" = lib.mkForce (linkDotfile "fuzzel/fuzzel.Prometheus.ini");
  xdg.configFile."mako/config" = lib.mkForce (linkDotfile "mako/config.Prometheus");


  xdg.configFile."wallpaper".source = lib.mkForce ../walls/town.png;

  home.packages = with pkgs; [
    zoom-us
  ];
}
