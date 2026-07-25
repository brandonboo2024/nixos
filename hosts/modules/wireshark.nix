{
  pkgs,
  config,
  inputs,
  lib,
  ...
}:
{
  programs.wireshark = {
    enable = false;
    dumpcap.enable = true;
    usbmon.enable = true;
  };
}
