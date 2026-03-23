# MicroVM for working on the dotfiles repository.
#

# Shares ~/src/dotfiles from the macOS host via virtiofs.
# Access via SSH: the VM gets a private IP from vfkit NAT
# (typically 192.168.64.x), visible from the host.
{ lib, ... }:

{
  imports = [
    ../microvm-base.nix
    ../../modules/microvm/dotfiles.nix
    ../../modules/microvm/github.nix
    ../../modules/microvm/pi.nix
  ];

  defaultSshDirectory = "/home/dev/src/dotfiles";

  microvm.shares = [
    {
      # Full dotfiles repo for development in this VM.
      proto = "virtiofs";
      tag = "dotfiles-repo";
      source = "/Users/bpinto/src/dotfiles";
      mountPoint = "/home/dev/src/dotfiles";
    }
  ];
}
