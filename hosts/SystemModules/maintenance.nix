{
  config, pkgs, inputs, autoUpgradeFlakeRef, ...
}:

{
  nix.gc = {
    automatic = true;
    dates = "01:00";
    options = "--delete-older-than 7d";
  };
}
