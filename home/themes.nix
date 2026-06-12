{ inputs, pkgs, ... }:

let
  berkeleyMono = inputs.assets.packages.${pkgs.stdenv.hostPlatform.system}.default;

  mkTheme =
    {
      kittyThemeFile,
      fontSize,
      cursorSize,
      terminalOpacity,
      yaziFlavor ? "nord",
    }:
    {
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = cursorSize;
      };

      kitty = {
        font = {
          package = berkeleyMono;
          name = "Berkeley Mono";
          size = fontSize;
        };
        themeFile = kittyThemeFile;
        backgroundOpacity = terminalOpacity;
      };

      yazi = {
        flavor = yaziFlavor;
        flavors = {
          ${yaziFlavor} = pkgs.yaziPlugins.${yaziFlavor};
        };
      };
    };
in
{
  yoga = mkTheme {
    kittyThemeFile = "vague";
    fontSize = 15;
    cursorSize = 30;
    terminalOpacity = 1.0;
  };

  thinkpad = mkTheme {
    kittyThemeFile = "rose-pine";
    fontSize = 14;
    cursorSize = 24;
    terminalOpacity = 1.0;
  };

  desktop_1 = mkTheme {
    kittyThemeFile = "kanagawa_dragon";
    fontSize = 15;
    cursorSize = 24;
    terminalOpacity = 1.0;
  };
}
