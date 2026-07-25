{
  pkgs,
  hostName,
  ...
}:

# Qt selects the Wayland platform plugin by default, which sioyek does not
# cope with on Hephaestus. It is wrapped onto xcb there and left alone
# everywhere else, rather than forcing every machine onto XWayland to suit
# one of them.
#
# The wrapper is a symlinkJoin, so share/applications/sioyek.desktop comes
# along either way, and its `Exec=sioyek %f` resolves through PATH to whichever
# build this machine installed. That is what xdg.mime points at.
let
  needsXcb = hostName == "Hephaestus";

  sioyekXcb = pkgs.symlinkJoin {
    name = "sioyek-xcb";
    paths = [ pkgs.sioyek ];
    buildInputs = [ pkgs.makeWrapper ];
    # Only the platform, deliberately. Setting QT_XCB_GL_INTEGRATION=xcb_egl
    # as well leaves sioyek running with no window ever appearing: the process
    # starts, logs normally and then sits there. Measured on this machine by
    # counting toplevels with lswt -- wayland: 0, xcb: 1, xcb+xcb_egl: 0.
    postBuild = ''
      wrapProgram $out/bin/sioyek \
        --set QT_QPA_PLATFORM xcb
    '';
  };
in
{
  programs.sioyek = {
    enable = true;
    package = if needsXcb then sioyekXcb else pkgs.sioyek;

    bindings = {
      # movements
      "screen_down" = [
        "J"
        "<c-d>"
      ];
      "screen_up" = [
        "K"
        "<c-u>"
      ];
      "move_left" = [ "l" ];
      "move_right" = [ "h" ];

      # rebind highlight as previously it was binded to "h"
      "add_highlight" = [ "H" ];
    };

    config = {
      "should_launch_new_instance" = "1";
    };
  };
}
