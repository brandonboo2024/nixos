{ ... }:

# ThinkPad laptop. Shared settings come from home/base.nix; only
# Daedalus-specific ones go here, e.g.
#   xdg.configFile."foo" = linkDotfile "foo";
{
  imports = [
    ./base.nix
    ./profiles/river.nix
  ];
}
