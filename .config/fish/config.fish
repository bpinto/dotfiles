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
--color=fg:#c0caf5,bg:#24283b,hl:#ff9e64 \
--color=fg+:#c0caf5,bg+:#292e42,hl+:#ff9e64 \
--color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff \
--color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a"

    # Set language environment
    set -gx LC_ALL "en_US.UTF-8"

    # XQuartz
    set -gx DISPLAY ":0"

    # Set main editor
    set -gx EDITOR vim

    # Set bat theme
    set -gx BAT_THEME tokyonight_storm

    # Build images using dockerbuild
    set -gx COMPOSE_DOCKER_CLI_BUILD 1
    set -gx DOCKER_BUILDKIT 1
end
