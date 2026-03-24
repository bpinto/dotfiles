# ── Theme ─────────────────────────────────────────────────────────────
source nu-themes/tokyo-storm.nu

$env.config.show_banner = false
$env.config.highlight_resolved_externals = true

# ── Direnv ────────────────────────────────────────────────────────────
# Initialize the PWD hook as an empty list if it doesn't exist
$env.config.hooks.env_change.PWD = $env.config.hooks.env_change.PWD? | default []

$env.config.hooks.env_change.PWD ++= [{||
  if (which direnv | is-empty) {
    return
  }

  direnv export json | from json | default {} | load-env
}]

# ── Docker compose helpers ────────────────────────────────────────────
# Shorthand for docker compose.
def --wrapped dk [...rest] {
  docker compose ...$rest
}

# Run a command via docker compose if DOCKER_SERVICES maps it to a service,
# otherwise run it directly.
#
# Looks up the command name first, then falls back to "*" (default service).
#
# DOCKER_SERVICES is a JSON object set via .envrc, e.g.:
#   export DOCKER_SERVICES='{"npm": "webpack", "*": "app"}'
def --wrapped docker-run [cmd: string, ...rest] {
  let services = ($env.DOCKER_SERVICES? | default '{}' | from json)
  let service = ($services | get -o $cmd | default ($services | get -o "*"))
  if $service != null { docker compose run --rm $service $cmd ...$rest } else { ^$cmd ...$rest }
}

# ── Dockerized command wrappers ───────────────────────────────────────
# Each command delegates to docker-run, which checks DOCKER_SERVICES
# for a service mapping. If mapped, runs via docker compose.
# Otherwise, runs the command directly.

def --wrapped bundle [...rest] { docker-run bundle ...$rest }
def --wrapped npm [...rest] { docker-run npm ...$rest }
def --wrapped npx [...rest] { docker-run npx ...$rest }
def --wrapped pnpm [...rest] { docker-run pnpm ...$rest }
def --wrapped pnpx [...rest] { docker-run pnpx ...$rest }
def --wrapped rails [...rest] { docker-run rails ...$rest }
def --wrapped rake [...rest] { docker-run rake ...$rest }
def --wrapped rspec [...rest] { docker-run rspec ...$rest }
def --wrapped rubocop [...rest] { docker-run rubocop ...$rest }
