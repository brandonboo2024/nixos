{ config, pkgs, ... }:
{
  console = {
    font = "ter-v32n";
    packages = with pkgs; [ terminus_font ];
    earlySetup = true;
  };
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --asterisks --cmd river";
      };
    };
  };
}
