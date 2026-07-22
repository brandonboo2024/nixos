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
    networkmanager_dmenu
  ];

  waylandTools = with pkgs; [
    chafa
    wl-clipboard
    wl-clip-persist
    grim
    slurp
    cliphist
    pamixer
    fuzzel
    swaybg
    swayidle
    swaylock
    foot
    bibata-cursors
    kanshi
    creek
    libnotify
    mako
  ];

  terminalTools = with pkgs; [
    tmux
    p7zip
    unzip
    bat
    skim
    claude-code
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
      inputs.codex.packages.${pkgs.stdenv.hostPlatform.system}.default
    ]
  );
}
