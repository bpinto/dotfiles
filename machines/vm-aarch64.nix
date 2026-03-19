{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./hardware/vm-aarch64.nix
    ./vm-shared.nix
  ];

  # VMware guest tools
  virtualisation.vmware.guest.enable = true;

  # Share host filesystem via VMware shared folders
  # Uncomment when shared folders are enabled in VMware Fusion settings.
  # fileSystems."/host" = {
  #   fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
  #   device = ".host:/";
  #   options = [
  #     "umask=22"
  #     "uid=1000"
  #     "gid=1000"
  #     "allow_other"
  #     "auto_unmount"
  #     "defaults"
  #   ];
  # };
}
