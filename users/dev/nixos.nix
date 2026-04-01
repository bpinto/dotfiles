{ config, ... }:

let
  user = config.users.users.dev;
in
{
  users.users.dev = {
    isNormalUser = true;
    home = "/home/dev";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQ6Phrt2tHAVfav8mVSgeg8R+1lqbzC7kaUGOSYo4S/ bruno@bpinto.com"
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
