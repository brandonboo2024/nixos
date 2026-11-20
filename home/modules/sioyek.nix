{
  pkgs,
  hostName,
  ...
}:

# sioyek shows no window under native Wayland on Hephaestus, so it runs on
# XWayland there only. The symlinkJoin keeps sioyek.desktop, which xdg.mime
# uses, pointing at whichever build is installed.
let
  needsXcb = hostName == "Hephaestus";

  sioyekXcb = pkgs.symlinkJoin {
    name = "sioyek-xcb";
    paths = [ pkgs.sioyek ];
    buildInputs = [ pkgs.makeWrapper ];
    # Only the platform: also setting QT_XCB_GL_INTEGRATION=xcb_egl loses
    # the window again (checked with lswt).
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

      # "h" is taken by move_right above.
      "add_highlight" = [ "H" ];
    };

    config = {
      "should_launch_new_instance" = "1";
    };
  };
}
