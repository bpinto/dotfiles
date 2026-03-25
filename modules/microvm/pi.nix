# Pi coding agent for microVMs.
#
# Mounts the host's .pi/agent/ directory via virtiofs (read-only) at
# /mnt/pi-agent. The home-manager pi module (modules/pi.nix) handles
# selectively symlinking config files into ~/.pi/agent/.
{
  config,
  pkgs,
  unstablePkgs,
  ...
}:

{
  # ── virtiofs share ──────────────────────────────────────────────────

  microvm.shares = [
    {
      proto = "virtiofs";
      tag = "pi-agent";
      source = "${config.hostHomeDirectory}/src/dotfiles/users/shared/dotfiles/.pi/agent";
      mountPoint = "/mnt/pi-agent";
      readOnly = true;
    }
  ];

  # ── Packages ────────────────────────────────────────────────────────

  environment.systemPackages = [ unstablePkgs.pi-coding-agent ];
}
