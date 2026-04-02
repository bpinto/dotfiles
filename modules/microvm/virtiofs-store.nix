# Workarounds for sharing the host /nix/store via virtiofs.
#
# When microvm.storeOnDisk is false, the host /nix/store is mounted into
# the VM from macOS (case-insensitive FS) via virtiofs. This requires:
#   1. A virtiofs share for /nix/store (read-only).
#   2. A systemd mount override to prevent a shutdown deadlock.
#   3. A TERMINFO_DIRS fix for ~nix~case~hack~ suffixes.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  storeOnDisk = config.microvm.storeOnDisk;
in
{
  config = lib.mkIf (!storeOnDisk) {
    # Share host's /nix/store into the VM (read-only) via virtiofs.
    microvm.shares = [
      {
        proto = "virtiofs";
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
      }
    ];

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

    # The host /nix/store shared from macOS (case-insensitive FS) via
    # virtiofs causes terminfo dirs to get ~nix~case~hack~ suffixes that
    # ncurses can't find. Prepend the ghostty terminfo package path
    # directly to TERMINFO_DIRS so ncurses finds xterm-ghostty without
    # going through the merged profile.
    environment.extraInit = ''
      export TERMINFO_DIRS="${pkgs.ghostty.terminfo}/share/terminfo''${TERMINFO_DIRS:+:$TERMINFO_DIRS}"
    '';
  };
}
