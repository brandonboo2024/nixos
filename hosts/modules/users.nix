{ pkgs, ... }:

# All three accounts are declared on every machine. Each host only ever logs
# in as its own, but the accounts are kept in step so that existing files and
# UIDs stay valid if a disk or home directory moves between machines.
#
# Only the groups every user needs everywhere belong here. A group that exists
# because a service is enabled is granted by that service's module instead --
# see hosts/modules/vm.nix -- so a host cannot end up in a group that does not
# exist on it.
#
# Passwords are not declarative: set one with `passwd` after the first switch.
let
  user = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # sudo
      "networkmanager"
    ];
    packages = with pkgs; [
      tree
    ];
  };
in
{
  users.users = {
    Daedalus = user;
    Prometheus = user;
    Hephaestus = user;
  };
}
