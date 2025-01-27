# Remove greeting
set fish_greeting

if not set -q fish_user_paths
    # Add brew binaries to PATH
    set -U fish_user_paths /usr/local/bin /usr/local/sbin /opt/homebrew/bin /opt/homebrew/sbin

    # Add XQuartz binaries to PATH
    set -U fish_user_paths $fish_user_paths /usr/X11/bin

    # Add ./node_modules/.bin to PATH
    # Usage: ln -sf ../node_modules/.bin/ .git/node_bin
    set -U fish_user_paths $fish_user_paths .git/node_bin
end

if status --is-interactive
    # Do not ignore hidden files when filtering files (e.g. vim integration)
    set -gx FZF_DEFAULT_COMMAND "rg --files --hidden -g'!.git'"
    set -gx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=none
  --color=bg+:#2e3c64 \
  --color=bg:#24283b \
  --color=border:#29a4bd \
  --color=fg:#c0caf5 \
  --color=gutter:#24283b \
  --color=header:#ff9e64 \
  --color=hl+:#2ac3de \
  --color=hl:#2ac3de \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#2ac3de \
  --color=query:#c0caf5:regular \
  --color=scrollbar:#29a4bd \
  --color=separator:#ff9e64 \
  --color=spinner:#ff007c \
"

    # Set language environment
    set -gx LC_ALL "en_US.UTF-8"

    # XQuartz
    set -gx DISPLAY ":0"

    # Set main editor
    set -gx EDITOR vim

    # GPG configuration
    set -gx GPG_TTY (tty)

    # Set bat theme
    set -gx BAT_THEME tokyonight_storm

    # Build images using dockerbuild
    set -gx COMPOSE_DOCKER_CLI_BUILD 1
    set -gx DOCKER_BUILDKIT 1

    # Use docker on Cliniko setup script
    set -gx DOCKER true
end
