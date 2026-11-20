{ lib, ... }:

# Every host uses the same btrfs layout (@, @home, @nix, @log; see each
# hardware-configuration.nix). These options merge into the generated mounts,
# so the generated files stay untouched. compress only affects new writes;
# data stays readable if the option is ever removed.
{
  fileSystems = lib.genAttrs [ "/" "/home" "/nix" "/var/log" ] (_: {
    options = [
      "compress=zstd"
      "noatime"
    ];
  });
}
