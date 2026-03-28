# macOS-specific SSH extensions: Keychain integration and encrypted host
# config via sops. Import alongside modules/ssh.nix.
{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.ssh = {
    includes = [
      config.sops.templates."ssh-hosts.conf".path
    ];

    matchBlocks = {
      "github.com" = {
        addKeysToAgent = lib.mkForce "yes";
        extraOptions = {
          UseKeychain = "yes";
        };
      };
    };
  };

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
}
