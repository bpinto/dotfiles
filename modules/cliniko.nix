# Cliniko-specific home-manager configuration.
#
# Nushell helpers, direnv docker-service mappings, and global gitignore
# for the Cliniko development workflow.
{
  config,
  lib,
  ...
}:

let
  envrcContent = ''
    export DOCKER_SERVICES='{"node": "webpack", "npm": "webpack", "npx": "webpack", "*": "app"}'
  '';
in
{
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
}
