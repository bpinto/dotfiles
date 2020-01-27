#fn console { cliniko:console $@ }
#fn deploy { cliniko:deploy $@ }

#use bash-wrapper
#use bindings
#use cliniko
#use n

# Autocompleter
#le:completer[git]={ bash-wrapper:complete $@ }

##############################################################################
# PLUGINS
##############################################################################

use cliniko
use prompt
use github.com/xiaq/edit.elv/smart-matcher

##############################################################################
# ENVIRONMENT
##############################################################################

# Homebrew bin
if (eq $E:ELVISH_PATH "") {
  E:ELVISH_PATH = 1
  paths = [/usr/local/bin $@paths]
}

# Set Neovim as terminal editor
E:EDITOR = "nvim"

# Do not ignore hidden files when filtering files (e.g. vim integration)
E:FZF_DEFAULT_COMMAND = "rg --files --hidden -g'!.git'"

# Set language environment
E:LC_ALL = "en_US.UTF-8"

##############################################################################
# FUNCTIONS
##############################################################################

# Aliases
fn dk [@a]{ e:docker-compose $@a }

# Colorize ls
fn ls [@a]{ e:ls -G $@a }

##############################################################################
# MAPPINGS
##############################################################################

# Emacs-like keybindings
use readline-binding
edit:insert:binding[Ctrl-B] = { edit:move-dot-left-word }
edit:insert:binding[Ctrl-F] = { edit:move-dot-right-word }

# Start location
#edit:insert:binding[Alt-C] = { edit:location:start }

##############################################################################
# PROMPT
##############################################################################

# Configure left prompt
edit:prompt = { prompt:prompt }

# Disable right prompt
edit:rprompt = { }

##############################################################################
# PLUGINS CONFIGURATION
##############################################################################

# A matcher that tries the following matchers: prefix match, smart-case prefix
# match, substring match, smart-case substring match, subsequence match and
# smart-case subsequence match.
smart-matcher:apply
