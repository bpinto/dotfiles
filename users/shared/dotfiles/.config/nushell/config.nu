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

