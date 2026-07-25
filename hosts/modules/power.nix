{ ... }:

# Battery-oriented power management. Imported by the laptop profile only: on
# the desktop these do nothing useful (thermald is Intel-specific, and the
# "battery" half of auto-cpufreq never applies).
#
# auto-cpufreq requires power-profiles-daemon to be off, since both drive the
# CPU governor and NixOS refuses to enable the two together. base.nix disables
# it on every machine, so there is nothing to do here.
{
  services.thermald.enable = true;

  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };
}
