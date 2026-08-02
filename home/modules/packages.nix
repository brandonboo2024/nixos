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
    imv
    mpv
    obsidian
    spotify
    telegram-desktop
    vesktop
    whatsapp-electron
  ];

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
    gh
    htop
    nh
    nix-tree
    p7zip
    skim
    tmux
    unzip
    jq
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
