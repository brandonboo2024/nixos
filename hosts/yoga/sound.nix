{ config, pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
		util-linux
		kmod
		i2c-tools
		bash
		coreutils
		gnugrep
		gnused
		gawk
	];

   boot.kernelModules = [ "i2c-dev" ];

	 systemd.services.turn-on-speakers = {
		 description = "Turn on speakers using i2c configuration";

		 wantedBy = [ "multi-user.target" "sleep.target" ];
     after = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target" ];

		 path = with pkgs; [ kmod i2c-tools util-linux coreutils ];

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
