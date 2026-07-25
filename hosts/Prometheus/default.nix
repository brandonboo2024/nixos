{ pkgs, ... }:

# Yoga laptop: Intel iGPU plus an NVIDIA dGPU, driven in PRIME offload mode,
# so the dGPU stays idle until a program is started with `nvidia-offload`.
{
  imports = [
    ./hardware-configuration.nix
    ../base.nix
    ../profiles/laptop.nix
    ../modules/nvidia.nix
    ./sound.nix
  ];

  hardware.nvidia.prime = {
    offload.enable = true;
    offload.enableOffloadCmd = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # HiDPI panel: the default console font is unreadably small.
  console = {
    font = "ter-v32n";
    packages = with pkgs; [ terminus_font ];
    earlySetup = true;
  };
}
