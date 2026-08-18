{ pkgsKernel, ... }:

# Keep every machine on the same deliberately selected kernel series. The
# immutable flake input fixes the exact patch release, while this package name
# remains stable across 7.1 patch updates.
{
  boot.kernelPackages = pkgsKernel.linuxPackages_7_1;
}
