{
  pkgs,
  inputs,
  ...
}:

# Packages every machine gets regardless of which desktop session it runs.
# The River session's own tools live in home/profiles/river.nix.
let
  # Graphical applications; every host currently wants the same set.
  desktopApps = with pkgs; [
    easyeffects
    imv
    mpv
    obsidian
    spotify
    telegram-desktop
    vesktop
    whatsapp-electron
    slack
    webex
  ];

  previewTools = with pkgs; [
    ffmpegthumbnailer # video
    mediainfo # audio
    poppler-utils # pdf, via pdftoppm
    vips # images, via vipsthumbnail for dirvish
  ];

  terminalTools = with pkgs; [
    bat
    chafa
    fastfetch
    gh
    htop
    nix-tree
    p7zip
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
    ]
    ++ (with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
      antigravity-cli
      claude-code
      codex
    ]);
}
