# Set vim as terminal editor
set -gx EDITOR vim

# # http://stackoverflow.com/questions/2499794/how-can-i-fix-a-locale-warning-from-perl
set -gx LC_CTYPE en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

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

#set -x LESS_TERMCAP_mb (printf "\033[01;31m")
#set -x LESS_TERMCAP_md (printf "\033[01;31m")
#set -x LESS_TERMCAP_me (printf "\033[0m")
#set -x LESS_TERMCAP_se (printf "\033[0m")
#set -x LESS_TERMCAP_so (printf "\033[38;5;246m")
#set -x LESS_TERMCAP_ue (printf "\033[0m")
#set -x LESS_TERMCAP_us (printf "\033[04;33;146m")

# golang
set -gx GOPATH $HOME/gocode
set PATH $GOPATH/bin $PATH
