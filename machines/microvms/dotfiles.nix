# MicroVM for working on the dotfiles repository.
#

{ lib, ... }:

{
  imports = [
    ../microvm-base.nix
    ../../modules/microvm/dotfiles.nix
    ../../modules/microvm/github.nix
    ../../modules/microvm/pi.nix
  ];

  defaultSshDirectory = "/home/dev/src/dotfiles";

  # Starship directory color — yellow
  home-manager.users.dev = {
    directoryColor = "#e0af68";
  };

  # Static IP so the macOS host can reach the VM at a known address
  staticIpAddress = "192.168.64.10";

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
