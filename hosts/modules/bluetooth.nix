{ ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true; # report battery level of connected devices
        FastConnectable = true; # faster reconnects, at some power cost
      };
      # Power on adapters at start and on hotplug.
      Policy.AutoEnable = true;
    };
  };
}
