{ inputs, pkgs, ... }:

# Berkeley Mono is the intended monospace font and ships in the private
# `assets` flake input; the Nerd Font entries below it are fallbacks that
# supply the glyphs it does not have (icons in the status bar, prompt and
# file manager).
{
  fonts.packages = with pkgs; [
    inputs.assets.packages.${pkgs.stdenv.hostPlatform.system}.default
    (ibm-plex.override { families = [ "serif" ]; })
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    noto-fonts-color-emoji
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [
        "Berkeley Mono"
        "Symbols Nerd Font Mono"
        "JetBrainsMono Nerd Font"
      ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
