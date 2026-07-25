{
  lib,
  pkgs,
  pkgsStable,
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
    pkgsStable.creek # pinned to stable: unstable's wayland 1.26 breaks creek's zig-wayland scanner
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

in
{
  home.packages = lib.unique (
    desktopPackages
    ++ waylandTools
    ++ terminalTools
    ++ [
      inputs.pi_flake.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.codex.packages.${pkgs.stdenv.hostPlatform.system}.default
    ]
  );
}
