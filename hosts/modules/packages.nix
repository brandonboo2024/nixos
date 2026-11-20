{ lib, pkgs, ... }:

# Only packages no enabled module already installs (e.g. bluez comes from
# hardware.bluetooth, xwayland and the portals from river-classic), so each
# dependency stays visible where it comes from.
let
  desktopPackages = with pkgs; [
    vim
  ];

  systemTools = with pkgs; [
    wget
    brightnessctl
    pass
  ];

  devTools = with pkgs; [
    llvmPackages_latest.clang-tools
    # Both compiler wrappers provide cc/c++; keep Clang on the generic names
    # while exposing the GNU compiler through gcc/g++.
    (lib.hiPrio llvmPackages_latest.clang)
    gcc
    bear
    gnumake
    gdb
    pinentry-curses
  ];
in
{
  environment.systemPackages = desktopPackages ++ systemTools ++ devTools;
}
