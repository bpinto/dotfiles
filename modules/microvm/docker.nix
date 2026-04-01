# Docker module for microVMs.
#
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    docker-buildx
    docker-compose
  ];

  # Add dev user to docker group so they can run docker without sudo
  users.users.dev.extraGroups = [ "docker" ];

  # ── Docker Engine ─────────────────────────────────────────────────────
  virtualisation.docker = {
    enable = true;

    daemon.settings = {
      # Fix DNS resolution inside containers / BuildKit.
      # systemd-resolved uses 127.0.0.53 as a stub resolver, which is
      # unreachable from Docker's network namespaces. Provide real
      # upstream DNS servers so apt-get, curl, etc. work during builds.
      dns = [
        "1.1.1.1"
        "1.0.0.1"
        "2606:4700:4700::1111"
        "2606:4700:4700::1001"
      ];
    };
  };

  # ── BuildKit ──────────────────────────────────────────────────────────
  # Allow BuildKit to use SSH (for private repo access in builds)
  systemd.services.docker.path = [ pkgs.openssh ];

  # Link docker-buildx as a Docker CLI plugin
  systemd.tmpfiles.rules = [
    "d /usr/local/lib/docker/cli-plugins 0755 root root -"
    "L+ /usr/local/lib/docker/cli-plugins/docker-buildx - - - - ${pkgs.docker-buildx}/bin/docker-buildx"
  ];
}
