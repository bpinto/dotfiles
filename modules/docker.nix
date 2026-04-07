# Dockerized command wrappers.
#
# Installs POSIX-exec'able shim scripts under ~/.local/bin for common dev
# commands (npm, node, rails, rspec, …). Each shim reads the DOCKER_SERVICES
# env var (typically set via direnv in a project's .envrc) and, if the command
# is mapped to a compose service, transparently runs it inside that container
# via `docker compose run --rm`. If there's no mapping it falls through to the
# real binary on $PATH.
#
# Enable on a per-project basis by creating a .envrc (see direnv) with:
#
#   export DOCKER_SERVICES='{"npm": "webpack", "rspec": "app", "*": "app"}'
#
# A "*" key acts as the fallback service for any wrapped command not listed
# explicitly. Omit DOCKER_SERVICES entirely (or leave a project's .envrc out)
# to fall back to the real binaries.
{
  lib,
  ...
}:

let
  # Commands to wrap. The shim dispatches based on its own basename, so a single
  # script is installed under each of these names.
  wrappedCmds = [
    "bundle"
    "node"
    "npm"
    "npx"
    "pnpm"
    "pnpx"
    "rails"
    "rake"
    "rspec"
    "rubocop"
    "ruby"
  ];

  mkShim = cmd: ''
    #!/usr/bin/env nu
    def --wrapped main [...rest: string] {
      let cmd = "${cmd}"
      let services = ($env.DOCKER_SERVICES? | default '{}' | from json)
      let service = ($services | get -o $cmd | default ($services | get -o '*'))

      if $service != null and (which docker | is-not-empty) {
        docker compose run --rm $service $cmd ...$rest
        return
      }

      # Fall through to the real binary by stripping ~/.local/bin from PATH
      # so we don't recursively re-invoke ourselves.
      with-env { PATH: ($env.PATH | where {|p| $p != $"($env.HOME)/.local/bin" }) } {
        ^$cmd ...$rest
      }
    }
  '';
in
{
  # Make sure ~/.local/bin is on PATH (ahead of system bins) so the shims win.
  home.sessionPath = [ "$HOME/.local/bin" ];

  # Install a dedicated shim per wrapped command name.
  home.file = lib.genAttrs (map (c: ".local/bin/${c}") wrappedCmds) (
    name:
    let
      cmd = baseNameOf name;
    in
    {
      text = mkShim cmd;
      executable = true;
    }
  );

  programs.nushell.extraConfig = lib.mkAfter ''
    # Shorthand for docker compose.
    def --wrapped dk [...rest] {
      docker compose ...$rest
    }

    # Provide a small "command" helper (like fish's) to run the underlying
    # external binary, bypassing the ~/.local/bin shims that route npm/node/etc.
    # through docker compose.
    def --wrapped command [cmd: string, ...rest] {
      with-env { PATH: ($env.PATH | where {|p| $p != $"($env.HOME)/.local/bin" }) } {
        ^$cmd ...$rest
      }
    }
  '';
}
