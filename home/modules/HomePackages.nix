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
    pamixer
    # dynamic menu
    bemenu
    # deskton launcher
    j4-dmenu-desktop
    swaybg
    foot
    bibata-cursors
    kanshi
    creek
  ];

  terminalTools = with pkgs; [
    tmux
    p7zip
    unzip
    bat
    skim
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
