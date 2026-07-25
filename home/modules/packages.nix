{
  pkgs,
  inputs,
  ...
}:

# Packages every machine gets regardless of which desktop session it runs.
# The River session's own tools live in home/profiles/river.nix.
let
  # Graphical applications. Not split per host because all three machines
  # currently want the same ones; split only if that stops being true.
  desktopApps = with pkgs; [
    easyeffects
    obsidian
    spotify
    telegram-desktop
    vesktop
    whatsapp-electron
  ];

  terminalTools = with pkgs; [
    bat
    chafa
    claude-code
    fastfetch
    p7zip
    skim
    timewarrior # config/scripts/time-track, bound to prefix+t in tmux
    tmux
    unzip
  ];
in
{
  home.packages =
    desktopApps
    ++ terminalTools
    ++ [
      inputs.pi_flake.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.codex.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
}
