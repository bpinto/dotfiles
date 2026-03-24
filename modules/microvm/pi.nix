# Pi coding agent for microVMs.
#
# Mounts the host's .pi/agent/ directory via virtiofs and points
# PI_CODING_AGENT_DIR at the mount. Files on the host must be
# world-readable (644) since virtiofs maps the macOS uid to root
# inside the VM.
{ pkgs, unstablePkgs, ... }:

{
  # ── virtiofs share ──────────────────────────────────────────────────

  microvm.shares = [
    {
      proto = "virtiofs";
      tag = "pi-agent";
      source = "/Users/bpinto/src/dotfiles/users/shared/dotfiles/.pi/agent";
      mountPoint = "/mnt/pi-agent";
    }
  ];

  # ── Packages ────────────────────────────────────────────────────────

  environment.systemPackages = [ unstablePkgs.pi-coding-agent ];

  # ── Environment ─────────────────────────────────────────────────────

  environment.variables.PI_CODING_AGENT_DIR = "/mnt/pi-agent";
}
