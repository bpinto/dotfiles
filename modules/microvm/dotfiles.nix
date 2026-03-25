# Shared dotfiles virtiofs share for microVMs.
#
{ config, lib, ... }:

{
  microvm.shares = [
    {
      mountPoint = "/mnt/dotfiles";
      proto = "virtiofs";
      readOnly = true;
      source = "${config.hostHomeDirectory}/src/dotfiles/users/shared/dotfiles";
      tag = "dotfiles";
    }
  ];
}
