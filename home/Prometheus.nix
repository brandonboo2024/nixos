{
  lib,
  pkgs,
  linkDotfile,
  ...
}:

# Yoga laptop. Shared settings come from home/base.nix; only
# Prometheus-specific ones go here.
{
  imports = [
    ./base.nix
    ./profiles/river.nix
    ./modules/obs.nix
  ];

  # The 3200x2000 panel runs at scale 1, so these variants size the UI in
  # physical pixels. River's equivalents are in config/river/hosts/Prometheus.sh.
  xdg.configFile."foot/foot.ini" = lib.mkForce (linkDotfile "foot/foot.Prometheus.ini");
  xdg.configFile."fuzzel/fuzzel.ini" = lib.mkForce (linkDotfile "fuzzel/fuzzel.Prometheus.ini");

  # Output priorities and jack-driven profiles for this laptop only.
  xdg.configFile."wireplumber/wireplumber.conf.d/51-output-routing.conf" =
    linkDotfile "wireplumber/Prometheus.conf";
  xdg.dataFile."wireplumber/scripts/prometheus-output-profile.lua" =
    linkDotfile "wireplumber/scripts/prometheus-output-profile.lua";

  xdg.configFile."wallpaper".source = lib.mkForce ../walls/town.png;

  programs.vscodium.profiles.default.userSettings = {
    "window.zoomLevel" = 2;
    "editor.fontFamily" = "'Berkeley Mono', monospace";
    "editor.fontSize" = 16;
  };

  home.packages = with pkgs; [
    zoom-us
  ];
}
