# MicroVM for working on the predbat repository.
#

{
  config,
  lib,
  pkgs,
  ...
}:

let
  hostHome = config.hostHomeDirectory;
  guestHome = "/home/dev";
in
{
  imports = [
    ../microvm-base.nix
    ../../modules/microvm/dotfiles.nix
    ../../modules/microvm/python.nix
  ];

  defaultSshDirectory = "${guestHome}/src/predbat";

  home-manager.users.dev = {
    imports = [
      ../../modules/pi.nix
    ];

    # Starship directory color — green
    directoryColor = "#9ece6a";

    # Global gitignore for uv
    home.file.".gitignore".text = ''
      .direnv
      .envrc
      uv.lock
    '';
  };

  environment.systemPackages = [ pkgs.pre-commit ];

  # Static IP so the macOS host can reach the VM at a known address
  staticIpAddress = "192.168.64.13";
}
