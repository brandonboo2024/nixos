{ ... }:

# ThinkPad laptop. Serves a local browserbench build over nginx.
{
  imports = [
    ./hardware-configuration.nix
    ../base.nix
    ../modules/nginx.nix
  ];

  services.nginx.virtualHosts."browserbench.test" = {
    root = "/srv/browserbench";
    default = true;
    locations."/".tryFiles = "$uri $uri/ =404";
  };
}
