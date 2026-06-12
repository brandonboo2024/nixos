{config,pkgs,pkgsStable,inputs,...}:

{
  programs.dank-material-shell = {
    enable = true;
    systemd = {
      enable = true; # auto startup
      restartIfChanged = true; # dynamic changes
    };
  };
}
