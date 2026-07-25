{ pkgs, pkgsStable, ... }:

# The user half of a River session: the tools river/init actually spawns or
# binds keys to, and the wallpaper it draws.
#
# Kept out of home/modules/packages.nix so that a machine trying a different
# compositor does not install the whole River toolchain, and so that the list
# is answerable from the session it belongs to. Imported by each host's home
# profile, mirroring hosts/profiles/river.nix on the system side.
{
  # The wallpaper lives here rather than being reached for at
  # ~/nixos/walls/... by the scripts: the dotfiles repository should not need
  # to know where this one is checked out. river/init exports $WALLPAPER from
  # this path, and lock-screen reads it.
  #
  # To use a different one on a machine, override this in home/<Host>.nix.
  xdg.configFile."wallpaper".source = ../../walls/vague.png;

  home.packages = with pkgs; [
    # Compositor furniture
    bibata-cursors
    kanshi
    swaybg
    swayidle
    swaylock
    pkgsStable.creek # pinned to stable: unstable's wayland 1.26 breaks creek's zig-wayland scanner

    # Terminal, launcher, notifications
    foot
    fuzzel
    mako
    libnotify
    networkmanager_dmenu

    # Clipboard and screenshots
    wl-clipboard
    wl-clip-persist
    cliphist
    grim
    slurp

    # Volume, bound to the media keys in river/init
    pamixer
  ];
}
