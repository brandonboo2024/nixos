{ pkgs, ... }:

# Everything that makes a machine a River machine: the compositor, the login
# command that starts it, and the environment a Wayland session needs.
#
# This is a profile rather than part of base.nix so that the active session is
# visible in a host's imports, and so that trying another compositor is a
# matter of importing a different profile instead of editing shared settings.
# XDG_CURRENT_DESKTOP in particular is a claim about the running session and
# would simply be false under anything else.
let
  riverSession = pkgs.writeShellScript "river-session" ''
    ${pkgs.river-classic}/bin/river
    river_status=$?
    ${pkgs.systemd}/bin/systemctl --user stop river-session.target
    exit "$river_status"
  '';
in
{
  programs.river-classic = {
    enable = true;
    xwayland.enable = true;
  };

  # Persuade the toolkits to speak Wayland natively rather than falling back
  # to XWayland. Applications that genuinely need XWayland override it for
  # themselves -- see home/modules/sioyek.nix.
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "river";
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --asterisks --cmd ${riverSession}";
      };
    };
  };
}
