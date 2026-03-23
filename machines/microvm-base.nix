# Base configuration shared by all microVMs.
#
# This module provides the common foundation: vfkit hypervisor, user-mode
# networking, nix store sharing, writable overlay, and SSH key sync.
#
# Each project module supplies its own shares, port forwards, packages, etc.
{
  config,
  hostPkgs,
  lib,
  pkgs,
  vmName,
  ...
}:

{
  imports = [
    ../users/dev/nixos.nix
  ];

  options.defaultSshDirectory = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    description = "Default directory to cd into on login.";
  };

  config = {
    environment.loginShellInit = lib.mkIf (config.defaultSshDirectory != null) ''
      cd ${config.defaultSshDirectory}
    '';
    nix.settings.experimental-features = "nix-command flakes";

    system.stateVersion = "25.11";

    # ── Hypervisor ──────────────────────────────────────────────────────
    microvm = {
      hypervisor = "vfkit";

      vcpu = lib.mkDefault 2;
      mem = lib.mkDefault 2048;

      # Control socket for graceful shutdown.
      socket = "control.socket";

      # Writable nix store overlay (tmpfs, ephemeral).
      # Required for home-manager activation and nix-daemon.
      writableStoreOverlay = "/nix/.rw-store";

      # Share host's /nix/store into the VM (read-only)
      shares = [
        {
          proto = "virtiofs";
          tag = "ro-store";
          source = "/nix/store";
          mountPoint = "/nix/.ro-store";
        }
        {
          proto = "virtiofs";
          tag = "ssh-keys";
          source = "/Users/bpinto/microvm/${vmName}/ssh-keys";
          mountPoint = "/mnt/ssh-keys";
        }
      ];

      # Persistent volume — survives reboots (root fs is ephemeral).
      volumes = [
        {
          mountPoint = "/var";
          image = "var.img";
          size = lib.mkDefault 8192; # MB
        }
      ];

      # User-mode NAT networking (only option on macOS/vfkit)
      # Each VM needs a unique MAC to avoid ARP conflicts on the host's
      # network — identical MACs cause lag and dropped SSH connections.
      interfaces = [
        {
          type = "user";
          id = "net0";
          mac =
            let
              hash = builtins.hashString "sha256" vmName;
              # Take 4 bytes from the hash for the last 4 octets
              b3 = builtins.substring 0 2 hash;
              b4 = builtins.substring 2 2 hash;
              b5 = builtins.substring 4 2 hash;
              b6 = builtins.substring 6 2 hash;
            in
            "02:00:${b3}:${b4}:${b5}:${b6}";
        }
      ];

      # The runner (vfkit) executes on the macOS host, not the Linux guest,
      # so it needs the host's (darwin) packages.
      vmHostPackages = hostPkgs;
    };

    # ── Networking ──────────────────────────────────────────────────────
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
      networkConfig = {
        DHCP = "yes";
        IPv6AcceptRA = true;
      };
    };

    # ── Systemd tuning ─────────────────────────────────────────────────
    systemd.settings.Manager = {
      # Fast shutdowns
      DefaultTimeoutStopSec = "5s";
    };

    # Fix for microvm shutdown hang (issue #170):
    # Without this, systemd tries to unmount /nix/store during shutdown,
    # but umount lives in /nix/store, causing a deadlock.
    systemd.mounts = [
      {
        what = "store";
        where = "/nix/store";
        overrideStrategy = "asDropin";
        unitConfig.DefaultDependencies = false;
      }
    ];

    # ── Home directories ────────────────────────────────────────────────
    # Bind-mount /var/home → /home so user data lives on the persistent
    # /var volume without a separate volume or mount-ordering issues.
    fileSystems."/home" = {
      device = "/var/home";
      options = [ "bind" ];
    };

    # ── Users ────────────────────────────────────────────────────────────
    users.users.root.password = "";
    security.sudo.wheelNeedsPassword = false;

    # ── Packages ─────────────────────────────────────────────────────────
    environment.enableAllTerminfo = true;

    environment.systemPackages = with pkgs; [
      ghostty.terminfo
    ];

    # The host /nix/store is shared from macOS (case-insensitive FS) via
    # virtiofs, so terminfo dirs get ~nix~case~hack~ suffixes that ncurses
    # can't find.  Prepend the ghostty terminfo package path directly to
    # TERMINFO_DIRS so ncurses finds xterm-ghostty without going through
    # the merged profile (where x/ becomes x~nix~case~hack~1/).
    environment.extraInit = ''
      export TERMINFO_DIRS="${pkgs.ghostty.terminfo}/share/terminfo''${TERMINFO_DIRS:+:$TERMINFO_DIRS}"
    '';

    # ── SSH key sync ─────────────────────────────────────────────────────
    # Copy SSH keys from host mount to /home/dev/.ssh/ with correct
    # permissions (SSH requires 600 + correct ownership).
    # The host directory /Users/bpinto/microvm/<vm>/ssh-keys is shared
    # via virtiofs; if it's empty, nothing is copied.
    systemd.services.ssh-key-sync = {
      description = "Sync SSH keys from host";
      wantedBy = [ "multi-user.target" ];
      after = [ "local-fs.target" ];

      unitConfig.RequiresMountsFor = [ "/mnt/ssh-keys" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script = ''
        if [ -d /mnt/ssh-keys ] && ls /mnt/ssh-keys/* >/dev/null 2>&1; then
          mkdir -p /home/dev/.ssh
          cp /mnt/ssh-keys/* /home/dev/.ssh/
          chown -R dev:users /home/dev/.ssh
          chmod 700 /home/dev/.ssh
          chmod 600 /home/dev/.ssh/* 2>/dev/null || true
          chmod 644 /home/dev/.ssh/*.pub 2>/dev/null || true
        fi
      '';
    };

    # ── Services ────────────────────────────────────────────────────────
    services.openssh = {
      enable = true;
      settings.PermitRootLogin = "yes";

      # Store host keys under /var so they persist across reboots
      # (the root filesystem is ephemeral, but /var is a persistent volume)
      hostKeys = [
        {
          path = "/var/lib/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };
  };
}
