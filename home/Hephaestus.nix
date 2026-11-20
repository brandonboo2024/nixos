{
  lib,
  pkgs,
  linkDotfile,
  ...
}:

# Desktop. Shared settings come from home/base.nix; only Hephaestus-specific
# ones go here.
{
  imports = [
    ./base.nix
    ./profiles/river.nix
  ];

  # Mains-powered, so it locks on idle but never suspends.
  xdg.configFile."swayidle/config" = lib.mkForce (linkDotfile "swayidle/config.Hephaestus");

  home.packages = with pkgs; [
    inkscape
  ];
}
