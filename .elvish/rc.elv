#use aliases
fn dk  { e:docker-compose $@ }
fn la  { e:ls -lah $@ }
fn vim { e:nvim $@ }

use bash-wrapper
use brew
use cliniko
use git-prompt

# Use git prompt
le:prompt={ git-prompt:prompt }

# Disable right prompt
le:rprompt={ put '' }

# Autocompleter
le:completer[git]={
  bash-wrapper:complete $@ | sed 's/ $//'
}

### Bindings ###
# Set Ctrl-L to clear terminal
le:binding[insert][Ctrl-L]={ clear > /dev/tty }
# Set Ctrl-N to start location
le:binding[insert][Ctrl-N]={ le:start-location }
# Set Alt-L to start navigation
le:binding[insert][Alt-l]={ le:start-nav }

# Emacs keybinding
le:binding[insert][Ctrl-A]={ le:move-dot-sol }
le:binding[insert][Ctrl-E]={ le:move-dot-eol }
le:binding[insert][Ctrl-B]={ le:move-dot-left-word }
le:binding[insert][Ctrl-F]={ le:move-dot-right-word }
