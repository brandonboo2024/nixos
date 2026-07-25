{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    profiles."gtzi7pmn.default".extensions.force = true;
  };
}
