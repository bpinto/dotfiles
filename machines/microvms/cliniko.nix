# MicroVM for working on the Cliniko project.
#

{
  lib,
  ...
}:

{
  imports = [
    ../microvm-base.nix
    ../../modules/microvm/docker.nix
    ../../modules/microvm/dotfiles.nix
    ../../modules/microvm/github.nix
    ../../modules/microvm/pi.nix
  ];

  defaultSshDirectory = "/home/dev/src/cliniko";

  home-manager.users.dev =
    { config, ... }:
    let
      envrcContent = ''
        export DOCKER_SERVICES='{"node": "webpack", "npm": "webpack", "npx": "webpack", "*": "app"}'
      '';
    in
    {
      # Starship directory color — orange
      directoryColor = "#ff9e64";

      # Global gitignore — excludes direnv files so .envrc (used for
      # DOCKER_SERVICES mapping) doesn't show up as untracked in repos.
      home.file.".gitignore".text = ''
        .direnv
        .envrc
      '';

      # Create .envrc with docker service mappings and allow it via direnv.
      home.activation.clinikoEnvrc = config.lib.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p /home/dev/src/cliniko
        cat > /home/dev/src/cliniko/.envrc << 'ENVRC'
        ${envrcContent}
        ENVRC
        export HOME=/home/dev
        PATH="${config.home.profileDirectory}/bin:$PATH" direnv allow /home/dev/src/cliniko/.envrc 2>/dev/null || true
      '';
    };

  # Static IP so the macOS host can reach the VM at a known address
  staticIpAddress = "192.168.64.11";

  # ── VM resources ────────────────────────────────────────────────────
  microvm.vcpu = 14;
  microvm.mem = 16384; # 16GB

  varVolumeSize = 65536; # 64 GB
}
