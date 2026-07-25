{ pkgs, ... }:

# The Yoga's speakers come up muted until the TAS2781 amplifiers are poked
# over i2c. 2pa-byps.sh does the poking; everything it needs is on the
# service's own `path` rather than in environment.systemPackages, so the unit
# carries its dependencies instead of borrowing them from the global profile.
{
  boot.kernelModules = [ "i2c-dev" ];

  systemd.services.turn-on-speakers = {
    description = "Turn on speakers using i2c configuration";

    wantedBy = [
      "multi-user.target"
      "sleep.target"
    ];
    after = [
      "suspend.target"
      "hibernate.target"
      "hybrid-sleep.target"
      "suspend-then-hibernate.target"
    ];

    # gnugrep, gnused and gawk are here because the script pipes through all
    # three. They used to resolve through environment.systemPackages by
    # accident, which meant the unit only worked because something else had
    # installed them.
    path = with pkgs; [
      kmod
      i2c-tools
      util-linux
      coreutils
      gnugrep
      gnused
      gawk
    ];

    serviceConfig = {
      Type = "oneshot";
      User = "root";

      ExecStart = "${pkgs.bash}/bin/bash ${./2pa-byps.sh}";
    };
  };

  boot.blacklistedKernelModules = [
    "snd_hda_scodec_tas2781_i2c"
  ];

  boot.extraModprobeConfig = ''
    blacklist snd_hda_scodec_tas2781_i2c
  '';
}
