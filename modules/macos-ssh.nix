# macOS-specific SSH module: base SSH config + Secretive integration +
# encrypted host config via sops.
{
  config,
  ...
}:

let
  secretiveAgentSocket = "~/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
in
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
          IdentityAgent = secretiveAgentSocket;
          UseKeychain = "yes";
        };
        forwardAgent = true;
        identityFile = "~/.ssh/id_ed25519";
      };

      "github.com" = {
        extraOptions.IdentityAgent = secretiveAgentSocket;
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
