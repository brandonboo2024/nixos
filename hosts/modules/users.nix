{ pkgs, ... }:

# All three accounts are declared on every machine. Each host only ever logs
# in as its own, but the accounts are kept in step so that existing files and
# UIDs stay valid if a disk or home directory moves between machines.
#
# Passwords are not declarative: set one with `passwd` after the first switch.
let
  mkUser = extraGroups: {
    isNormalUser = true;
    extraGroups = [
      "wheel" # sudo
      "networkmanager"
    ]
    ++ extraGroups;
    packages = with pkgs; [
      tree
    ];
  };
in
{
  users.users = {
    Daedalus = mkUser [ ];
    Prometheus = mkUser [
      "wireshark"
      "docker"
    ];
    Hephaestus = mkUser [
      "wireshark"
      "docker"
    ];
  };
}
