{ ... }:

# Battery-oriented power management, imported by the laptop profile.
# auto-cpufreq needs power-profiles-daemon off, which hosts/base.nix does.
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
