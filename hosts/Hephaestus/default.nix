# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  pkgsStable,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ../base.nix
    ./hardware-configuration.nix
    ../modules/wireshark.nix
    ../modules/vm.nix
  ];

  services = {
    desktopManager.plasma6.enable = true;
  };

  # specific packages/ settings to be changed here

  # for nvidia driver
  hardware.enableAllFirmware = true;
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.nvidia = {
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    powerManagement = {
      enable = true;
      finegrained = false;
    };
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.prime = {
    # enables you to run 'nvidia-offload <program>' to offload a program to your dGPU
    sync.enable = true;
    amdgpuBusId = "PCI:11:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # services.tor = {
  #   enable = true;
  #   client.enable = true;
  #   openFirewall = true;
  #   relay = {
  #     enable = true;
  #     role = "relay";
  #   };
  #   settings = {
  #     UseBridges = true;
  #     ClientTransportPLugin = "obfs4 exec ${pkgs.obfs4}/bin/lyrebird";
  #     Bridge = "obfs4 IP:ORPort [fingerprint]";
  #   };
  # };

}
