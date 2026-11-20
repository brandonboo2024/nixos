{ pkgsKernel, ... }:

# Every machine runs the same kernel series. The flake input fixes the patch
# release; this attribute name only changes when moving to a new series.
{
  boot.kernelPackages = pkgsKernel.linuxPackages_7_3;
}
