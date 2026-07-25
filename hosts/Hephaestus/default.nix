{ ... }:

# Desktop: AMD iGPU plus an NVIDIA dGPU, driven in PRIME sync mode so the
# dGPU renders everything.
{
  imports = [
    ./hardware-configuration.nix
    ../base.nix
    ../modules/nvidia.nix
    ../modules/wireshark.nix
    ../modules/vm.nix
  ];

  services.desktopManager.plasma6.enable = true;

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
