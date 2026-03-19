{ ... }:

{
  networking = {
    # Disable legacy dhcpcd (systemd-networkd handles DHCP)
    useDHCP = false;

    # Use systemd-networkd for network management
    useNetworkd = true;
  };

  # Enable systemd-resolved for DNS resolution
  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
  };

  # Match all non-loopback interfaces and enable DHCP.
  systemd.network.networks."50-default" = {
    matchConfig.Name = "en* eth*";
    networkConfig = {
      DHCP = "yes";
      IPv6AcceptRA = true;
      DNS = [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];
    };
    dhcpV4Config.UseDNS = true;
    dhcpV6Config.UseDNS = true;
  };
}
