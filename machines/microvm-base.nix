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
    users.users.root.password = "";
    security.sudo.wheelNeedsPassword = false;
  };
}
