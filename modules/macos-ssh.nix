# macOS-specific SSH module: base SSH config + Keychain integration +
# encrypted host config via sops.
{
  config,
  ...
}:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    includes = [
      config.sops.templates."ssh-hosts.conf".path
    ];

    matchBlocks = {
      "192.168.64.*" = {
        addKeysToAgent = "8h";
        extraOptions = {
          UseKeychain = "yes";
        };
        identityFile = "~/.ssh/id_ed25519";
      };

      "github.com" = {
        addKeysToAgent = "yes";
        extraOptions = {
          UseKeychain = "yes";
        };
        identityFile = "~/.ssh/github";
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
