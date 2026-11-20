{ hostName, ... }:

# Retention policy: old generations, GC roots and logs.
{
  # nh replaces nix.gc (the two cannot both be enabled). NH_FLAKE lets
  # `nh os switch` run without arguments. Cleaning keeps the last 7 days and
  # never fewer than 5 generations, and also drops stale result/direnv roots.
  programs.nh = {
    enable = true;
    flake = "/home/${hostName}/nixos";
    clean = {
      enable = true;
      dates = "daily";
      extraArgs = "--keep-since 7d --keep 5";
    };
  };

  services.journald.settings.Journal.SystemMaxUse = "500M";
}
