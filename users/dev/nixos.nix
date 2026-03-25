{ config, ... }:

let
  user = config.users.users.dev;
in
{
  users.users.dev = {
    isNormalUser = true;
    home = "/home/dev";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKd7PMzAWjdjMW68JDlADapXcf8hgPqBEgV7h3Hq7n4b Bruno Pinto"
    ];
  };

  # Recursively fix ownership of everything under the dev user's home.
  #
  # Some directories (e.g. .config, src) are created by systemd mount
  # units or other root services before home-manager runs. Without
  # correct ownership, home-manager fails with "Permission denied"
  # when creating symlinks.
  systemd.tmpfiles.settings."10-home-dev-chown" = {
    "/var${user.home}" = {
      Z = {
        user = user.name;
        group = "users";
      };
    };
  };
}
