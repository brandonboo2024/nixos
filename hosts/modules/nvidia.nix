{ config, ... }:

# Settings common to every machine with an NVIDIA dGPU. Each host sets
# hardware.nvidia.prime itself: the bus IDs differ, and the desktop uses sync
# (dGPU renders everything) while the laptop uses offload (dGPU only for
# `nvidia-offload <program>`, to save battery).
{
  hardware.enableAllFirmware = true;
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  hardware.nvidia = {
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}
