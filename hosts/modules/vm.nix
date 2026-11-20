{ pkgs, hostName, ... }:

# Local Docker and MySQL for development. Importing this module enables both
# and adds the host's user to their groups.
{
  networking.firewall.allowedTCPPorts = [
    80
    443
    3306
  ];

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    storageDriver = "btrfs";
  };

  services.mysql = {
    enable = true;
    package = pkgs.mysql84;
  };

  users.users.${hostName}.extraGroups = [
    "docker"
    "mysql"
  ];
}
