{
  config,
  lib,
  linkDotfile,
  pkgs,
  pkgsStable,
  ...
}:

# The user half of a River session (system half: hosts/profiles/river.nix):
# its services, the tools it binds keys to, and the wallpaper.
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
  # Exposed at ~/.config/wallpaper so config/ need not know where this repo
  # lives; river/init and lock-screen read it. Override per host with mkForce.
  xdg.configFile."wallpaper".source = ../../walls/vague.png;

  # Use the mutable config from config/ instead of the generated one.
  services.fnott.enable = true;
  xdg.configFile."fnott/fnott.ini" = lib.mkForce (linkDotfile "fnott/fnott.ini");

  # Graphical services are bound to a River-specific target that river/init
  # starts and river-session stops, so none outlive the compositor.
  wayland.systemd.target = riverSessionTarget;
  systemd.user.targets.river-session.Unit = {
    Description = "River compositor session";
    Documentation = [ "man:systemd.special(7)" ];
    BindsTo = [ "graphical-session.target" ];
    Wants = [ "graphical-session-pre.target" ];
    After = [ "graphical-session-pre.target" ];
  };

  # Home Manager runs swayidle; its config is ~/.config/swayidle/config. PATH
  # covers the commands that config calls, including the helper scripts.
  services.swayidle = {
    enable = true;
    extraArgs = [ "-w" ];
    systemdTargets = [ riverSessionTarget ];
  };
  services.wob.enable = true;
  systemd.user.services.swayidle.Service.Environment = lib.mkForce [
    "PATH=${swayidlePath}:${config.xdg.configHome}/scripts"
  ];

  # Tie the Emacs daemon (home/modules/emacs.nix) to the River session.
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
    libnotify
    networkmanager_dmenu

    # Clipboard and screenshots
    wl-clipboard
    wl-clip-persist
    cliphist
    grim
    slurp

    # Volume and media controls, bound in river/reload
    pamixer
    playerctl
  ];
}
