# MicroVM for working on the dotfiles repository.
#

{ config, lib, ... }:

let
  hostHome = config.hostHomeDirectory;
  # Use a static guestHome literal to avoid evaluating config.users during module
  # evaluation which can create recursive option evaluation paths.
  guestHome = "/home/dev";
in
{
  imports = [
    ../microvm-base.nix
    ../../modules/microvm/dotfiles.nix
    ../../modules/microvm/github.nix
    ../../modules/microvm/pi.nix
  ];

  defaultSshDirectory = "${guestHome}/src/dotfiles";

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
      source = "${hostHome}/src/dotfiles";
      mountPoint = "${guestHome}/src/dotfiles";
    }
  ];
}
