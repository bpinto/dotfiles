# Remove greeting
set fish_greeting

if not set -q fish_user_paths
  # Add brew binaries to PATH
  set -U fish_user_paths /usr/local/bin /usr/local/sbin

  # Add XQuartz binaries to PATH
  set -U fish_user_paths $fish_user_paths /usr/X11/bin
end

if status --is-interactive
  # Do not ignore hidden files when filtering files (e.g. vim integration)
  set -gx FZF_DEFAULT_COMMAND "rg --files --hidden -g'!.git'"

  # XQuartz
  set -gx DISPLAY ":0"
end
