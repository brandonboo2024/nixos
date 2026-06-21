{config,pkgs,pkgsStable,inputs,...}:

{
  programs.dank-material-shell = {
    enable = false;
    systemd = {
      enable = true; # auto startup
      restartIfChanged = true; # dynamic changes
    };
  };
}
