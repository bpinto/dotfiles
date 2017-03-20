# Set neovim as terminal editor
set -gx EDITOR nvim

# Show folder name only on theme
set -g theme_short_path yes

# Ruby configuration
set -g theme_display_rbenv 'yes'
set -g theme_display_rbenv_gemset 'yes'
set -g theme_display_rbenv_with_gemfile_only 'yes'

# Less colors
set -gx LESS_TERMCAP_so \e'[01;44m' # begin standout-mode – info
set -gx LESS_TERMCAP_mb \e'[01;31m' # enter blinking mode
set -gx LESS_TERMCAP_md \e'[01;38;5;75m' # enter double-bright mode
set -gx LESS_TERMCAP_me \e'[0m' # turn off all appearance modes (mb, md, so, us)
set -gx LESS_TERMCAP_se \e'[0m' # leave standout mode
set -gx LESS_TERMCAP_ue \e'[0m' # leave underline mode
set -gx LESS_TERMCAP_us \e'[04;38;5;200m' # enter underline mode

# HiDPI support for QT
set -gx QT_SCALE_FACTOR 2

# Configure ssh-agent
set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"
