{
  config,
  lib,
  pkgs,
  pkgsStable,
  ...
}:

# The user half of a River session: its supervised services, the tools it uses
# or binds keys to, and the wallpaper it draws.
#
# Kept out of home/modules/packages.nix so that a machine trying a different
# compositor does not install the whole River toolchain, and so that the list
# is answerable from the session it belongs to. Imported by each host's home
# profile, mirroring hosts/profiles/river.nix on the system side.
let
  riverSessionTarget = "river-session.target";
  swayidlePath = lib.makeBinPath [
    pkgs.bash
    pkgs.libnotify
    pkgs.swaylock
    pkgs.systemd
  ];
in
{
  # The wallpaper lives here rather than being reached for at
  # ~/nixos/walls/... by the scripts: the dotfiles repository should not need
  # to know where this one is checked out. river/init exports $WALLPAPER from
  # this path, and lock-screen reads it.
  #
  # To use a different one on a machine, override this in home/<Host>.nix.
  xdg.configFile."wallpaper".source = ../../walls/vague.png;

  # River imports its display environment before starting this target. Keeping
  # the target compositor-specific prevents graphical services from leaking
  # across logout or a future compositor experiment.
  wayland.systemd.target = riverSessionTarget;
  systemd.user.targets.river-session.Unit = {
    Description = "River compositor session";
    Documentation = [ "man:systemd.special(7)" ];
    BindsTo = [ "graphical-session.target" ];
    Wants = [ "graphical-session-pre.target" ];
    After = [ "graphical-session-pre.target" ];
  };

  # Keep the portable config in ~/.config/swayidle/config. Home Manager owns
  # only the process lifecycle and the Nix-specific command search path.
  services.swayidle = {
    enable = true;
    extraArgs = [ "-w" ];
    systemdTargets = [ riverSessionTarget ];
  };
  systemd.user.services.swayidle.Service.Environment = lib.mkForce [
    "PATH=${swayidlePath}:${config.xdg.configHome}/scripts"
  ];

  # services.emacs is enabled in modules/emacs.nix without a default target;
  # River supplies the graphical lifetime here.
  systemd.user.services.emacs = {
    Unit = {
      After = [ riverSessionTarget ];
      PartOf = [ riverSessionTarget ];
    };
    Install.WantedBy = [ riverSessionTarget ];
  };

  home.packages = with pkgs; [
    # Compositor furniture
    bibata-cursors
    kanshi
    swaybg
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
    playerctl
  ];
}
