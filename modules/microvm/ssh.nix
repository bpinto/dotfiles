# SSH and key-sync module for microVMs.
{ config, ... }:

let
  guestUser = config.users.users.dev;
in
{
  services.openssh = {
    enable = true;

    # Store host keys under /var so they persist across reboots
    # (the root filesystem is ephemeral, but /var is a persistent volume)
    hostKeys = [
      {
        path = "/var/lib/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];

    settings = {
      # SSH via dev user only, no root login.
      PermitRootLogin = "no";
      # Keep agent forwarding enabled
      AllowAgentForwarding = "yes";
    };
  };

  # Copy SSH and age keys from host mount to the guest with correct
  # permissions. Runs as a systemd oneshot after the virtiofs mount is
  # available (activation scripts run too early - before mounts).
  systemd.services.key-sync = {
    description = "Sync SSH and age keys from host mount";
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
        # Keep directories traversable (e.g. ~/.ssh/agent used by sshd for
        # forwarded-agent listener sockets), and set sane file modes.
        find ${guestUser.home}/.ssh -maxdepth 1 -type d -exec chmod 700 {} +
        find ${guestUser.home}/.ssh -maxdepth 1 -type f ! -name '*.pub' -exec chmod 600 {} +
        find ${guestUser.home}/.ssh -maxdepth 1 -type f -name '*.pub' -exec chmod 644 {} +
      fi

      # Age keys (/mnt/keys/age → ~/.config/sops/age)
      if [ -d /mnt/keys/age ] && ls /mnt/keys/age/* >/dev/null 2>&1; then
        mkdir -p ${guestUser.home}/.config/sops/age
        cp /mnt/keys/age/* ${guestUser.home}/.config/sops/age/
        chown -R ${guestUser.name}:users ${guestUser.home}/.config
        chmod 700 ${guestUser.home}/.config/sops/age
        chmod 600 ${guestUser.home}/.config/sops/age/* 2>/dev/null || true
      fi
    '';
  };
}
