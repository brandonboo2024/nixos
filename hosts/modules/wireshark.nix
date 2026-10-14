{ hostName, pkgs, ... }:

# Packet capture. Importing this module is all a host needs to do: it installs
# wireshark, sets up the privileged dumpcap helper, and puts that machine's
# user in the group allowed to use it.
{
  programs.wireshark = {
    enable = true;
    # The module defaults to wireshark-cli; this is the Qt GUI (it includes the CLI tools).
    package = pkgs.wireshark;
    dumpcap.enable = true;
    usbmon.enable = true;
  };

  users.users.${hostName}.extraGroups = [ "wireshark" ];
}
