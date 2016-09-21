#use aliases
fn dk  { e:docker-compose $@ }
fn la  { e:ls -lah $@ }
fn vim { e:nvim $@ }

use bash-wrapper
use bindings
use brew
use cliniko
use git-prompt

# Use git prompt
le:prompt={ git-prompt:prompt }

# Disable right prompt
le:rprompt={ put '' }

# Autocompleter
le:completer[git]={ bash-wrapper:complete $@ }
