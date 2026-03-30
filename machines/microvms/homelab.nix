# MicroVM for working on the homelab repository.
#

{
  config,
  ...
}:

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
  ];

  defaultSshDirectory = "${guestHome}/src/homelab";

  home-manager.users.dev = {
    imports = [
      ../../modules/pi.nix
    ];

    # Starship directory color — cyan
    directoryColor = "#73daca";
  };

  # Static IP so the macOS host can reach the VM at a known address
  staticIpAddress = "192.168.64.12";
}
