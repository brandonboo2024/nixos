# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  pkgsStable,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ../base.nix
    ./hardware-configuration.nix
    ./nginx.nix
  ];
  networking.hostName = "Daedalus"; # Define your hostname.
  # specific packages/ settings to be changed here
}
