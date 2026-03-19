{ config, pkgs, ... }:

{
  sops.secrets.user_bpinto_password = {
    neededForUsers = true;
  };

  users.users.bpinto = {
    isNormalUser = true;
    home = "/home/bpinto";
    extraGroups = [
      "docker"
      "wheel"
    ];
    shell = pkgs.nushell;

    hashedPasswordFile = config.sops.secrets.user_bpinto_password.path;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKd7PMzAWjdjMW68JDlADapXcf8hgPqBEgV7h3Hq7n4b Bruno Pinto"
    ];
  };
}
