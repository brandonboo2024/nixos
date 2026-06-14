{ lib, pkgs, ... }:
let
  desktopPackages = with pkgs; [
    vim
    zathura
  ];

  systemTools = with pkgs; [
    wget
    bluez
    bluez-tools
    blueman
    brightnessctl
    xwayland
    xwayland-satellite
    xkbcomp
    xkeyboard-config
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
    yazi
    pass
  ];

  devTools = with pkgs; [
    git
    clang-tools
    llvmPackages_latest.clang
    bear
    gnumake
    gdb
    pinentry-curses
    # wireshark
  ];
in
{
  environment.systemPackages = lib.unique (
    desktopPackages
    ++ systemTools
    ++ devTools
  );
}
