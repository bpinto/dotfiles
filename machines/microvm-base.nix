# Base configuration shared by all microVMs.
{ pkgs, ... }:

{
  # ── Imports ─────────────────────────────────────────────────────────

  imports = [
    ../modules/microvm/home-manager.nix
    ../modules/microvm/hypervisor.nix
    ../modules/microvm/networking.nix
    ../modules/microvm/shell.nix
    ../modules/microvm/ssh.nix
    ../modules/microvm/virtiofs-store.nix
    ../users/dev/nixos.nix
  ];

  # ── Configuration ───────────────────────────────────────────────────

  config = {
    # Global packages available in the VM
    environment.systemPackages = with pkgs; [
      ripgrep
    ];

    # Bind-mount /var/home → /home so user data lives on the persistent
    # /var volume without a separate volume or mount-ordering issues.
    fileSystems."/home" = {
      device = "/var/home";
      options = [ "bind" ];
    };

    # Enables flakes and allows unfree packages.
    nix.settings.experimental-features = "nix-command flakes";
    nixpkgs.config.allowUnfree = true;

    system.stateVersion = "25.11";

    # ── Systemd tuning ─────────────────────────────────────────────────
    systemd.settings.Manager = {
      # Fast shutdowns
      DefaultTimeoutStopSec = "5s";
    };

    # ── Users ────────────────────────────────────────────────────────────
    users.users.root.hashedPassword = "$6$oE3LIeLA9DVnhvtg$OAX116gGGGUGk8ZpVa16QB5ArSwLktkWhk/MHP6xayx6qAwRP56lxnMkUPOa2xFu6u3N88bnrGN6Z1P0qNF/y1";

    # ── Sudo ─────────────────────────────────────────────────────────────
    # No blanket root access — dev is not in wheel. Grant only the
    # specific commands that need elevated privileges. This prevents
    # the guest from modifying nftables rules that restrict host access.
    security.sudo = {
      wheelNeedsPassword = false;
      extraRules = [
        {
          users = [ "dev" ];
          commands = [
            # Allow systemctl for service management (e.g. restarting docker).
            {
              command = "/run/current-system/sw/bin/systemctl";
              options = [ "NOPASSWD" ];
            }
            # Allow journalctl for log inspection.
            {
              command = "/run/current-system/sw/bin/journalctl";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];
    };
  };
}
