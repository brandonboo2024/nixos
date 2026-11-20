{ pkgs, ... }:

# Every account exists on every machine, so UIDs stay valid if a disk moves
# between them. Service groups (docker, wireshark, ...) are added by the module
# that enables the service. Set passwords with `passwd` after the first switch.
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
