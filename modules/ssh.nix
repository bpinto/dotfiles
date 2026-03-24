# SSH configuration for home-manager.
{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Encrypted hostnames decrypted at activation time.
  sops.secrets.ssh_home_assistant_hostname = { };

  # SSH config snippet with decrypted hostnames, included by programs.ssh.
  sops.templates."ssh-hosts.conf" = {
    content = ''
      Host home-assistant
        Hostname ${config.sops.placeholder.ssh_home_assistant_hostname}
        User hass
        IdentityFile ~/.ssh/homelab
    '';
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [
      config.sops.templates."ssh-hosts.conf".path
    ];
    matchBlocks = {
      "github.com" = {
        identityFile = "~/.ssh/github";
        extraOptions = {
          AddKeysToAgent = "yes";
          UseKeychain = "yes";
        };
      };
    };
  };
}
