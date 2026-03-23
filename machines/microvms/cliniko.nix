# MicroVM for working on the Cliniko project.
#

{
  lib,
  ...
}:

{
  imports = [
    ../microvm-base.nix
    ../../modules/microvm/docker.nix
    ../../modules/microvm/dotfiles.nix
    ../../modules/microvm/github.nix
    ../../modules/microvm/pi.nix
  ];

  defaultSshDirectory = "/home/dev/src/cliniko";

  # Static IP so the macOS host can reach the VM at a known address
  staticIpAddress = "192.168.64.11";

  # ── VM resources ────────────────────────────────────────────────────
  microvm.vcpu = 14;
  microvm.mem = 16384; # 16GB

  varVolumeSize = 65536; # 64 GB
}
