{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  desktopPackages = with pkgs; [
    fastfetch
    spotify
    obsidian
    easyeffects
    vesktop
    telegram-desktop
    whatsapp-electron
  ];

  waylandTools = with pkgs; [
    wl-clipboard
    wl-clip-persist
    grim
    slurp
    cliphist
    # dynamic menu
    bemenu
    # deskton launcher
    j4-dmenu-desktop
    swaybg
  ];

  terminalTools = with pkgs; [
    git-credential-email
    tmux
    p7zip
    unzip
    bat
    skim
    typst
    timewarrior
    codex
  ];

  deploymentTools = with pkgs; [
  ];
in
{
  home.packages = lib.unique (
    desktopPackages
    ++ waylandTools
    ++ terminalTools
    ++ deploymentTools
    ++ [
      inputs.pi_flake.packages.${pkgs.stdenv.hostPlatform.system}.default
    ]
  );
}
