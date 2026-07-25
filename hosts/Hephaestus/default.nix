{ ... }:

# Desktop: AMD iGPU plus an NVIDIA dGPU, driven in PRIME sync mode so the
# dGPU renders everything.
{
  imports = [
    ./hardware-configuration.nix
    ../base.nix
    ../profiles/river.nix
    ../modules/nvidia.nix
    ../modules/vm.nix
  ];

  services.desktopManager.plasma6.enable = true;

  # No power daemon runs here: auto-cpufreq is for the laptops and
  # power-profiles-daemon is off everywhere (see hosts/base.nix). Pin the
  # governor instead, so the desktop keeps running flat out. amd-pstate-epp
  # offers only "performance" and "powersave".
  powerManagement.cpuFreqGovernor = "performance";

  hardware.nvidia.powerManagement = {
    enable = true;
    finegrained = false;
  };

  hardware.nvidia.prime = {
    sync.enable = true;
    amdgpuBusId = "PCI:11:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}
