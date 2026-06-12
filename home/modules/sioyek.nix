{ lib, config, pkgs, ... }:
{

  programs.sioyek = {
    enable = true;
    package = pkgs.symlinkJoin{
      name = "sioyek";
      paths = [pkgs.sioyek];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/sioyek \
          --set QT_QPA_PLATFORM xcb \
          --set QT_XCB_GL_INTEGRATION xcb_egl
      '';
    };
    bindings = {
      # movements
      "screen_down" = ["J" "<c-d>" ];
      "screen_up" = ["K" "<c-u>"];
      "move_left" = ["l"];
      "move_right" = ["h"];

      # rebind highlight as previously it was binded to "h"
      "add_highlight" = ["H"];
    };
    config = {
      "should_launch_new_instance" = "1";
      # startup_commands = lib.mkForce [
      #   "toggle_custom_color"
      # ];
    };
  };
}
