# Shared dotfiles virtiofs share for microVMs.
#
{ lib, ... }:

{
  microvm.shares = [
    {
      mountPoint = "/mnt/dotfiles";
      proto = "virtiofs";
      readOnly = true;
      source = "/Users/bpinto/src/dotfiles/users/shared/dotfiles";
      tag = "dotfiles";
    }
  ];
}
