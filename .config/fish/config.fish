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

    # Set language environment
    set -gx LC_ALL "en_US.UTF-8"

    # XQuartz
    set -gx DISPLAY ":0"

    # Set main editor
    set -gx EDITOR vim

    # Set bat theme
    set -gx BAT_THEME everforest

    # Build images using dockerbuild
    set -gx COMPOSE_DOCKER_CLI_BUILD 1
    set -gx DOCKER_BUILDKIT 1
end
