# MicroVM for working on the Cliniko project.
#

{
  config,
  ...
}:

let
  guestHome = config.users.users.dev.home;
in
{
  imports = [
    ../microvm-base.nix
    ../../modules/microvm/cliniko-dev.nix
    ../../modules/microvm/docker.nix
    ../../modules/microvm/dotfiles.nix
  ];

  defaultSshDirectory = "${guestHome}/src/cliniko";

  home-manager.users.dev = {
    imports = [
      ../../modules/cliniko.nix
      ../../modules/skills/conventional-commits.nix
      ../../modules/skills/react.nix
    ];

    # Starship directory color — orange
    directoryColor = "#ff9e64";
  };

  # Static IP so the macOS host can reach the VM at a known address
  staticIpAddress = "192.168.64.11";

  # ── VM resources ────────────────────────────────────────────────────
  microvm.vcpu = 14;
  microvm.mem = 16384; # 16GB

  varVolumeSize = 65536; # 64 GB
}
