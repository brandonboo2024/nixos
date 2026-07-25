{ hostName, ... }:

# Packet capture. Importing this module is all a host needs to do: it installs
# wireshark, sets up the privileged dumpcap helper, and puts that machine's
# user in the group allowed to use it.
#
# Imported by no host at the moment. Add it to a host's imports when you next
# need to capture there.
{
  programs.wireshark = {
    enable = true;
    dumpcap.enable = true;
    usbmon.enable = true;
  };

  users.users.${hostName}.extraGroups = [ "wireshark" ];
}
