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

  # The 3200x2000 panel runs at scale 1, so font sizes are in physical pixels
  # and need to differ from every other machine. Point the two single-file
  # configs at this machine's variants; river reads its own values from
  # config/river/hosts/Prometheus.sh.
  xdg.configFile."foot/foot.ini" = lib.mkForce (linkDotfile "foot/foot.Prometheus.ini");
  xdg.configFile."fuzzel/fuzzel.ini" = lib.mkForce (linkDotfile "fuzzel/fuzzel.Prometheus.ini");

  home.packages = with pkgs; [
    zoom-us
  ];
}
