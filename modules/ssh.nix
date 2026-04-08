# Shared SSH module for non-macOS environments (e.g. microVMs).
{
  config,
  lib,
  pkgs,
  ...
}:

let
  gitSignKeyPath = "${config.home.homeDirectory}/.ssh/git_sign";
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks."github.com".extraOptions.IdentityAgent = "\${SECRETIVE_AUTH_SOCK}";
  };

  services.ssh-agent = {
    enable = true;
    # Our nushell extraEnv (see modules/nushell.nix) owns SSH_AUTH_SOCK and
    # points it at /run/user/%i/ssh-agent, so the stock integration would
    # be redundant and would race with our ordering.
    enableNushellIntegration = false;
  };

  sops.secrets.ssh_git_sign_passphrase = { };

  systemd.user.services.ssh-add-git-sign = {
    Install.WantedBy = [ "default.target" ];

    Unit = {
      After = [
        "sops-nix.service"
        "ssh-agent.service"
      ];
      Description = "Load ~/.ssh/git_sign into ssh-agent using sops-nix secret";
      Requires = [
        "sops-nix.service"
        "ssh-agent.service"
      ];
    };

    Service = {
      Environment = [ "SSH_AUTH_SOCK=%t/ssh-agent" ];
      ExecStart = pkgs.writeShellScript "ssh-add-git-sign" ''
        set -euo pipefail

        if [ ! -f "${gitSignKeyPath}" ]; then
          exit 0
        fi

        if [ ! -s "${config.sops.secrets.ssh_git_sign_passphrase.path}" ]; then
          exit 0
        fi

        askpass_script="$(${lib.getExe' pkgs.coreutils "mktemp"})"
        trap '${lib.getExe' pkgs.coreutils "rm"} -f "$askpass_script"' EXIT

        ${lib.getExe' pkgs.coreutils "cat"} > "$askpass_script" <<ASKPASS
        #!${pkgs.runtimeShell}
        ${lib.getExe' pkgs.coreutils "cat"} "${config.sops.secrets.ssh_git_sign_passphrase.path}"
        ASKPASS
        ${lib.getExe' pkgs.coreutils "chmod"} 700 "$askpass_script"

        SSH_ASKPASS="$askpass_script" \
        SSH_ASKPASS_REQUIRE=force \
          ${lib.getExe' pkgs.openssh "ssh-add"} "${gitSignKeyPath}" < /dev/null > /dev/null 2>&1 || true
      '';
      Type = "oneshot";
    };
  };
}
