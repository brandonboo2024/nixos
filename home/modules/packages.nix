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

  # Thumbnailers and metadata readers. Emacs' dirvish shells out to these for
  # file previews and silently drops the dispatcher when the binary is absent,
  # so a missing entry here shows up as a preview pane that renders nothing
  # rather than as an error. p7zip below already covers archive previews.
  previewTools = with pkgs; [
    ffmpegthumbnailer # video
    mediainfo # audio
    poppler-utils # pdf, via pdftoppm
    vips # images, via vipsthumbnail
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
    ++ previewTools
    ++ [
      inputs.pi_flake.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.codex.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
}
