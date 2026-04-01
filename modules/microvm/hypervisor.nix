# Hypervisor module for microVMs.
{
  config,
  hostPkgs,
  lib,
  vmName,
  ...
}:

let
  hostHome = config.hostHomeDirectory;
in
{
  options.hostHomeDirectory = lib.mkOption {
    type = lib.types.str;
    default = "/Users/bpinto";
    description = "Home directory of the user on the macOS host (used for virtiofs share sources).";
  };

  options.varVolumeSize = lib.mkOption {
    type = lib.types.int;
    default = 8192;
    description = "Size of the persistent /var volume in MB.";
  };

  config.microvm = {
    hypervisor = "vfkit";

    vcpu = lib.mkDefault 2;
    mem = lib.mkDefault 4096;

    # Control socket for graceful shutdown.
    socket = "control.socket";

    # Mount /nix/store from the VM store disk (read-only).
    storeOnDisk = true;
    # Build was failing with default squashfs store type.
    storeDiskType = "squashfs";

    # Writable nix store overlay (tmpfs, ephemeral).
    # Required for home-manager activation and nix-daemon.
    writableStoreOverlay = "/nix/.rw-store";

    shares = [
      # Share the SSH keys from the host for easy access in the VM (e.g. for git).
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
}
