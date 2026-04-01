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
    networking = {
      # Allow all inbound traffic from the host — we trust it fully.
      firewall.enable = false;

      hostName = "${vmName}-vm";

      useDHCP = false;
      useNetworkd = true;

      # ── Outbound restrictions ─────────────────────────────────────────────
      # Block the guest from reaching host services on the gateway
      # (192.168.64.1) except DNS, which is required for name resolution.
      nftables = {
        enable = true;

        tables.restrict-host = {
          family = "inet";
          content = ''
            chain output {
              type filter hook output priority 0; policy accept;

              # Allow replies to connections initiated by the host (e.g. SSH).
              ct state established,related accept

              # Allow DNS (udp+tcp 53) to the gateway — it is our resolver.
              ip daddr 192.168.64.1 udp dport 53 accept
              ip daddr 192.168.64.1 tcp dport 53 accept

              # Drop everything else destined for private/LAN ranges.
              # This prevents the guest from reaching host services or
              # other devices on the local network.
              ip daddr { 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 } counter drop
            }
          '';
        };
      };
    };

    services.resolved.enable = true;

    systemd.network = {
      enable = true;

      networks."10-e" = {
        matchConfig.Name = "e*";

        address = [ "${config.staticIpAddress}/24" ];
        dns = [ "192.168.64.1" ];
        gateway = [ "192.168.64.1" ];
      };
    };
  };
}
