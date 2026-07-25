{
  pkgs,
  config,
  lib,
  ...
}:
{
  networking.firewall.allowedTCPPorts = [
    80
    443
    2026
  ];

  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;

    # virtualHosts."browserbench.test" = {
    #   root = "/srv/browserbench";
    #   default = true;
    #   locations."/" = {
    #     tryFiles = "$uri $uri/ =404";
    #   };
    # };
  };
}
