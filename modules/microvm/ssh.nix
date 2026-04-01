# SSH and key-sync module for microVMs.
{ config, ... }:

let
  guestUser = config.users.users.dev;
in
{
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";

    # Store host keys under /var so they persist across reboots
    # (the root filesystem is ephemeral, but /var is a persistent volume)
    hostKeys = [
      {
        path = "/var/lib/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  # Copy SSH keys from host mount to the guest with correct
  # permissions. Runs as a systemd oneshot after the virtiofs mount is
  # available (activation scripts run too early - before mounts).
  systemd.services.key-sync = {
    description = "Sync SSH keys from host mount";
    after = [ "mnt-keys.mount" ];
    requires = [ "mnt-keys.mount" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      # SSH keys (/mnt/keys/ssh → ~/.ssh)
      if [ -d /mnt/keys/ssh ] && ls /mnt/keys/ssh/* >/dev/null 2>&1; then
        mkdir -p ${guestUser.home}/.ssh
        cp /mnt/keys/ssh/* ${guestUser.home}/.ssh/
        chown -R ${guestUser.name}:users ${guestUser.home}/.ssh
        chmod 700 ${guestUser.home}/.ssh
        chmod 600 ${guestUser.home}/.ssh/* 2>/dev/null || true
        chmod 644 ${guestUser.home}/.ssh/*.pub 2>/dev/null || true
      fi

      # Age keys (/mnt/keys/age → ~/.config/sops/age)
      if [ -d /mnt/keys/age ] && ls /mnt/keys/age/* >/dev/null 2>&1; then
        mkdir -p ${guestUser.home}/.config/sops/age
        cp /mnt/keys/age/* ${guestUser.home}/.config/sops/age/
        chown -R ${guestUser.name}:users ${guestUser.home}/.config/sops/age
        chmod 700 ${guestUser.home}/.config/sops/age
        chmod 600 ${guestUser.home}/.config/sops/age/* 2>/dev/null || true
      fi
    '';
  };
}
