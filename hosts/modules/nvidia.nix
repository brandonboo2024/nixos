{ config, ... }:

# Settings common to every machine with an NVIDIA dGPU. The PRIME block is
# deliberately NOT here: it is per-machine, both for the bus IDs and because
# the two laptops and the desktop want different behaviour.
#
#   sync    - the dGPU drives everything, all the time (desktop).
#   offload - the iGPU drives everything and the dGPU is used only for
#             programs launched with `nvidia-offload <program>` (laptops,
#             where always-on would cost battery).
#
# So each host still sets hardware.nvidia.prime itself.
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
