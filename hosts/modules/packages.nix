{ pkgs, ... }:

# Only packages nothing else already pulls in. A service module that needs a
# tool installs it as part of enabling the service, so listing it again here
# is not belt and braces, it is a second copy that hides where the dependency
# really comes from. Removed on those grounds:
#
#   bluez                     hardware.bluetooth.enable
#   xwayland                  programs.river-classic.xwayland.enable
#   xdg-desktop-portal-wlr    xdg.portal.extraPortals, set by river-classic
#   xdg-desktop-portal-gtk    likewise
#
# xwayland-satellite went with them: it exists for compositors with no
# XWayland of their own, and River has one. xkbcomp and xkeyboard-config are
# X11-era; River takes its keymap through libxkbcommon.
let
  desktopPackages = with pkgs; [
    vim
  ];

  systemTools = with pkgs; [
    wget
    bluez-tools
    brightnessctl
    pass
  ];

  devTools = with pkgs; [
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
  environment.systemPackages = desktopPackages ++ systemTools ++ devTools;
}
