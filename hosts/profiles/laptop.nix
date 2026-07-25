{ ... }:

# Settings shared by the machines that run on a battery. Imported by
# Prometheus and Daedalus, not by the desktop.
{
  imports = [
    ../modules/power.nix
  ];
}
