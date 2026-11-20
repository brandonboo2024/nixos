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
    ../modules/wireshark.nix
    ../modules/ssh-server.nix
  ];

  services.desktopManager.plasma6.enable = true;

  # udev rules, 32-bit graphics, and Remote Play ports for Steam.
  programs.steam.enable = true;

  # No power daemon runs here (see hosts/base.nix), so set the governor
  # directly. amd-pstate-epp offers only "performance" and "powersave"; the
  # latter still boosts on demand, driven by the EPP hint.
  powerManagement.cpuFreqGovernor = "powersave";

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
