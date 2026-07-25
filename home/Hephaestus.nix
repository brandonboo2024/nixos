{
  lib,
  pkgs,
  linkDotfile,
  ...
}:

# Desktop. Username, home directory and the shared dotfile symlinks come from
# home/base.nix and the flake; only Hephaestus-specific settings go here.
{
  imports = [
    ./base.nix
  ];

  # Mains-powered, so it locks on idle but never suspends.
  xdg.configFile."swayidle/config" = lib.mkForce (linkDotfile "swayidle/config.Hephaestus");

  home.packages = with pkgs; [
    inkscape
    steam
  ];
}
