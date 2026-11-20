{
  config,
  lib,
  pkgs,
  ...
}:

# The River session: compositor, greetd login, and Wayland environment. A
# profile rather than part of base.nix so another compositor can be tried by
# importing a different one.
let
  riverSession = pkgs.writeShellScript "river-session" ''
    ${lib.optionalString (config.networking.hostName == "Prometheus") ''
      # Restrict River to Intel while retaining NVIDIA application offload.
      # Resolve the PCI path because WLR_DRM_DEVICES uses colons as separators.
      intel_drm="$(${pkgs.coreutils}/bin/readlink -e \
        /dev/dri/by-path/pci-0000:00:02.0-card)" || exit 1
      export WLR_DRM_DEVICES="$intel_drm"
    ''}

    # Stop the user session target when River exits, so its services do not
    # outlive the compositor.
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

  # Prefer native Wayland in every toolkit. Apps that need XWayland override
  # this themselves (see home/modules/sioyek.nix).
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
