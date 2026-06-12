{
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };
		refind.enable = false;
    systemd-boot.enable = true;
		systemd-boot.configurationLimit = 10;
  };
}
