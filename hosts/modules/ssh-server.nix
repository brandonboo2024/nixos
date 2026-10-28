{ hostName, ... }:

# Accept SSH logins to this machine's user from the home LAN, so a laptop can
# use the desktop's GPU. Keys only: password and root logins are refused.
#
# The port is opened on the wired interface alone rather than through
# services.openssh.openFirewall, which would open it on every interface.
# Clients connect by IP address.
{
  services.openssh = {
    enable = true;
    openFirewall = false;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ hostName ];
    };
  };

  networking.firewall.interfaces.enp8s0.allowedTCPPorts = [ 22 ];
}

# Client keys are deliberately kept out of this repository. sshd still reads
# ~/.ssh/authorized_keys, so authorize a client by appending its
# ~/.ssh/id_ed25519.pub to that file on this host.
