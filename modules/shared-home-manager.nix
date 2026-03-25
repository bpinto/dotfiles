# Shared home-manager options and config used across all machines.
#
# Import this as a home-manager module (e.g., via sharedModules) and set
# isMicrovm per machine.
{ config, lib, ... }:

{
  options.isMicrovm = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Whether this home-manager configuration runs inside a microVM.";
  };

  options.dotfilesPath = lib.mkOption {
    type = lib.types.str;
    default =
      if config.isMicrovm then
        "/mnt/dotfiles"
      else
        "${config.home.homeDirectory}/src/dotfiles/users/shared/dotfiles";
    description = "Path to shared dotfiles directory (used by home-manager modules).";
  };

  options.directoryColor = lib.mkOption {
    type = lib.types.str;
    default = "#2ac3de"; # teal
    description = "Color for the starship directory module (per-machine).";
  };
}
