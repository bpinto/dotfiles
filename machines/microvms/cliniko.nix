# MicroVM for working on the Cliniko project.
#

{
  config,
  lib,
  ...
}:

let
  guestHome = config.users.users.dev.home;
in
{
  imports = [
    ../microvm-base.nix
    ../../modules/microvm/docker.nix
    ../../modules/microvm/dotfiles.nix
    ../../modules/microvm/github.nix
    ../../modules/microvm/pi.nix
  ];

  defaultSshDirectory = "${guestHome}/src/cliniko";

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

      # Console — SSH into cliniko-dev infrastructure via the CLI tool.
      programs.nushell.extraConfig = lib.mkAfter ''
        def --wrapped console [...rest] {
          with-env { TERM: xterm-256color } {
            ~/src/cliniko-dev/cli/index.mjs ssh --preserve-current-context --quiet ...$rest
          }
        }
      '';

      # Global gitignore — excludes direnv files so .envrc (used for
      # DOCKER_SERVICES mapping) doesn't show up as untracked in repos.
      home.file.".gitignore".text = ''
        .direnv
        .envrc
      '';

      # Create .envrc with docker service mappings and allow it via direnv.
      home.activation.clinikoEnvrc = config.lib.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p ${config.home.homeDirectory}/src/cliniko
        cat > ${config.home.homeDirectory}/src/cliniko/.envrc << 'ENVRC'
        ${envrcContent}
        ENVRC
        export HOME=${config.home.homeDirectory}
        PATH="${config.home.profileDirectory}/bin:$PATH" direnv allow ${config.home.homeDirectory}/src/cliniko/.envrc 2>/dev/null || true
      '';
    };

  # Static IP so the macOS host can reach the VM at a known address
  staticIpAddress = "192.168.64.11";

  # ── VM resources ────────────────────────────────────────────────────
  microvm.vcpu = 14;
  microvm.mem = 16384; # 16GB

  varVolumeSize = 65536; # 64 GB
}
