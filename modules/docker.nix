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

  shimScript = ''
    #!/usr/bin/env nu
    def --wrapped main [...rest: string] {
      let cmd = ($env.CURRENT_FILE | path basename)
      let shim_dir = ($env.CURRENT_FILE | path dirname)
      let services = ($env.DOCKER_SERVICES? | default '{}' | from json)
      let service = ($services | get -o $cmd | default ($services | get -o '*'))

      if $service != null and (which docker | is-not-empty) {
        docker compose run --rm $service $cmd ...$rest
        return
      }

      with-env { PATH: ($env.PATH | where {|p| $p != $shim_dir }) } {
        ^$cmd ...$rest
      }
    }
  '';
in
{
  # Make sure ~/.local/bin is on PATH (ahead of system bins) so the shims win.
  home.sessionPath = [ "$HOME/.local/bin" ];

  # Install the shim under each wrapped command name.
  home.file = lib.genAttrs (map (c: ".local/bin/${c}") wrappedCmds) (_: {
    text = shimScript;
    executable = true;
  });

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
