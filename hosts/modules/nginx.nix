{ ... }:

# Baseline nginx for machines that serve something locally. Virtual hosts and
# any additional ports belong to the host that needs them: allowedTCPPorts is
# a list, so a host can simply declare the extra ports it wants.
{

  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
  };
}
