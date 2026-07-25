{ hostName, ... }:

# Docker. Importing this module is all a host needs to do: it turns on the
# daemon and puts that machine's user in the group required to talk to it.
{
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };

  users.users.${hostName}.extraGroups = [ "docker" ];
}
