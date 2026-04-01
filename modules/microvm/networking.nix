# Networking module for microVMs.
{
  config,
  lib,
  vmName,
  ...
}:

{
  options.staticIpAddress = lib.mkOption {
    type = lib.types.str;
    default = lib.mkUndefined;
    description = ''
      Static IPv4 address for the VM on the Apple Virtualization.framework
      NAT network (192.168.64.0/24). The gateway is assumed to be
      192.168.64.1. This option is mandatory and must be set in
      machines/microvms/<name>.nix as: staticIpAddress = "192.168.64.X";
    '';
    example = "192.168.64.10";
  };

  config = {
    # TODO: Re-enable firewall with explicit outbound rules. The guest can
    # currently reach the host (gateway, typically 192.168.64.1) and any
    # service listening on it.
    networking.firewall.enable = false;

    networking.hostName = "${vmName}-vm";

    services.resolved.enable = true;
    networking.useDHCP = false;
    networking.useNetworkd = true;

    systemd.network.enable = true;
    systemd.network.networks."10-e" = {
      matchConfig.Name = "e*";

      address = [ "${config.staticIpAddress}/24" ];
      gateway = [ "192.168.64.1" ];
      dns = [ "192.168.64.1" ];
    };
  };
}
