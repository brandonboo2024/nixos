{ pkgs, hostName, ... }:

# Docker. Importing this module is all a host needs to do: it turns on the
# daemon and puts that machine's user in the group required to talk to it.
{
  networking.firewall.allowedTCPPorts = [
    80
    443
    3306
  ];
  
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };

  services.mysql = {
    enable = true;
    package = pkgs.mysql84;
  };

  users.users.${hostName}.extraGroups = [ "docker" "mysql" ];
}
