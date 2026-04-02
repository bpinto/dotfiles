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
    # Build was failing with default erofs store type.
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
        readOnly = true;
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
            byte = offset: builtins.substring (offset * 2) 2 hash;
          in
          "02:00:${byte 0}:${byte 1}:${byte 2}:${byte 3}";
      }
    ];

    # The runner (vfkit) executes on the macOS host, not the Linux guest,
    # so it needs the host's (darwin) packages.
    vmHostPackages = hostPkgs;
  };
}
