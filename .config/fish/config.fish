# Remove greeting
set fish_greeting

if not set -q fish_user_paths
  # Add brew binaries to PATH
  set -U fish_user_paths /usr/local/bin /usr/local/sbin
end
