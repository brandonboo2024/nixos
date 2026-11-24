{ pkgs, pkgsStable, ... }:

# Yoga laptop: Intel iGPU plus an NVIDIA dGPU, driven in PRIME offload mode,
# so the dGPU stays idle until a program is started with `nvidia-offload`.
{
  imports = [
    ./hardware-configuration.nix
    ../base.nix
    ../profiles/river.nix
    ../profiles/laptop.nix
    ../modules/nvidia.nix
    ./sound.nix
    ../modules/vm.nix
    ../modules/wireshark.nix
  ];

  hardware.nvidia.prime = {
    offload.enable = true;
    offload.enableOffloadCmd = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # VA-API driver for the Intel iGPU, which drives the display. Without it
  # libva finds no driver for i915 and browsers, mpv and video calls decode
  # on the CPU. libva picks it from the render node's kernel driver, so
  # LIBVA_DRIVER_NAME is left unset and NVIDIA offload keeps its own driver.
  hardware.graphics.extraPackages = [ pkgs.intel-media-driver ];

  # Failed boots with linux-firmware 20260810 logged AX211 RT ucode startup
  # failures and a Bluetooth hardware error. Keep Prometheus on the known-good
  # 20260622 package independently from the shared kernel policy.
  nixpkgs.overlays = [
    (_final: _previous: {
      linux-firmware = pkgsStable.linux-firmware;
    })
  ];

  # HiDPI panel: the default console font is unreadably small.
  console = {
    font = "ter-v32n";
    packages = with pkgs; [ terminus_font ];
    earlySetup = true;
  };
}
