# Base configuration shared by all microVMs.
#
# This module provides the common foundation: vfkit hypervisor, user-mode
# networking, nix store sharing, writable overlay, and SSH key sync.
#
# Each project module supplies its own shares, port forwards, packages, etc.
{
  config,
  dgalarza-claude-code-workflows,
  hostPkgs,
  lib,
  nixvim,
  pkgs,
  sops-nix,
  spnngl-pi-ext,
  unstablePkgs,
  vercel-labs-agent-skills,
  vmName,
  ...
}:

{
  # ── Options ─────────────────────────────────────────────────────────

  options.hostHomeDirectory = lib.mkOption {
    type = lib.types.str;
    default = "/Users/bpinto";
    description = "Home directory of the user on the macOS host (used for virtiofs share sources).";
  };

  options.defaultSshDirectory = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    description = "Default directory to cd into on login.";
  };

  options.staticIpAddress = lib.mkOption {
    # Make this option mandatory by declaring it as a plain string without
    # a default. lib.mkUndefined is used so evaluation fails if the option
    # is not set by the VM module.
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

  options.varVolumeSize = lib.mkOption {
    type = lib.types.int;
    default = 8192;
    description = "Size of the persistent /var volume in MB.";
  };

  # ── Imports ─────────────────────────────────────────────────────────

  imports = [
    ../users/dev/nixos.nix
  ];

  # ── Configuration ───────────────────────────────────────────────────

  config =
    let
      hostHome = config.hostHomeDirectory;
      guestUser = config.users.users.dev;
    in
    {
      environment.loginShellInit = lib.optionalString (config.defaultSshDirectory != null) ''
        if [ -d ${config.defaultSshDirectory} ]; then cd ${config.defaultSshDirectory}; fi
      '';

      environment.interactiveShellInit = ''
        # Launch nushell for interactive sessions.
        # Bash remains the login shell for POSIX compatibility.
        if [[ $- == *i* && -z "$IN_NUSHELL" && "$(id -u)" -ne 0 ]]; then
          exec env IN_NUSHELL=1 nu --login
        fi
      '';

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit
            dgalarza-claude-code-workflows
            sops-nix
            spnngl-pi-ext
            unstablePkgs
            vercel-labs-agent-skills
            ;
        };
        sharedModules = [
          ../modules/shared-home-manager.nix
          nixvim.homeModules.nixvim
          sops-nix.homeManagerModules.sops
          { isMicrovm = true; }
        ];
        users.dev = import ../users/dev/home-manager.nix;
      };

      nix.settings.experimental-features = "nix-command flakes";
      nixpkgs.config.allowUnfree = true;

      system.stateVersion = "25.11";

      # ── Hypervisor ──────────────────────────────────────────────────────
      microvm = {
        hypervisor = "vfkit";

        vcpu = lib.mkDefault 2;
        mem = lib.mkDefault 4096;

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
            tag = "keys";
            source = "${hostHome}/microvm/${vmName}/keys";
            mountPoint = "/mnt/keys";
          }
        ];

        # Persistent volume — survives reboots (root fs is ephemeral).
        volumes = [
          {
            mountPoint = "/var";
            image = "var.img";
            size = config.varVolumeSize;
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

        address = [ "${config.staticIpAddress}/24" ];
        gateway = [ "192.168.64.1" ];
        dns = [ "192.168.64.1" ];
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
        ripgrep
      ];

      # The host /nix/store is shared from macOS (case-insensitive FS) via
      # virtiofs, so terminfo dirs get ~nix~case~hack~ suffixes that ncurses
      # can't find.  Prepend the ghostty terminfo package path directly to
      # TERMINFO_DIRS so ncurses finds xterm-ghostty without going through
      # the merged profile (where x/ becomes x~nix~case~hack~1/).
      environment.extraInit = ''
        export TERMINFO_DIRS="${pkgs.ghostty.terminfo}/share/terminfo''${TERMINFO_DIRS:+:$TERMINFO_DIRS}"
      '';

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

      # ── Key sync ──────────────────────────────────────────────────────────
      # Copy SSH keys from host mount to the guest with correct
      # permissions. Runs as a systemd oneshot after the virtiofs mount is
      # available (activation scripts run too early - before mounts).
      systemd.services.key-sync = {
        description = "Sync SSH keys from host mount";
        after = [ "mnt-keys.mount" ];
        requires = [ "mnt-keys.mount" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          # SSH keys (/mnt/keys/ssh → ~/.ssh)
          if [ -d /mnt/keys/ssh ] && ls /mnt/keys/ssh/* >/dev/null 2>&1; then
            mkdir -p ${guestUser.home}/.ssh
            cp /mnt/keys/ssh/* ${guestUser.home}/.ssh/
            chown -R ${guestUser.name}:users ${guestUser.home}/.ssh
            chmod 700 ${guestUser.home}/.ssh
            chmod 600 ${guestUser.home}/.ssh/* 2>/dev/null || true
            chmod 644 ${guestUser.home}/.ssh/*.pub 2>/dev/null || true
          fi

          # Age keys (/mnt/keys/age → ~/.config/sops/age)
          if [ -d /mnt/keys/age ] && ls /mnt/keys/age/* >/dev/null 2>&1; then
            mkdir -p ${guestUser.home}/.config/sops/age
            cp /mnt/keys/age/* ${guestUser.home}/.config/sops/age/
            chown -R ${guestUser.name}:users ${guestUser.home}/.config/sops/age
            chmod 700 ${guestUser.home}/.config/sops/age
            chmod 600 ${guestUser.home}/.config/sops/age/* 2>/dev/null || true
          fi
        '';
      };
    };
}
