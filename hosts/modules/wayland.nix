{ ... }:

# The River session and the environment variables that persuade toolkits to
# use Wayland natively rather than falling back to XWayland.
{
  programs.river-classic = {
    enable = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "river";
  };

  xdg.mime.defaultApplications = {
    "application/pdf" = [
      "sioyek-x11.desktop"
      "org.pwmt.zathura-pdf-mupdf.desktop"
    ];
  };
}
