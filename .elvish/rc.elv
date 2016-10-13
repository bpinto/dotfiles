#use aliases
fn console { cliniko:console $@ }
fn deploy { cliniko:deploy $@ }
fn dk  { e:docker-compose $@ }
fn la  { e:ls -lah $@ }
fn vim { e:nvim $@ }

use bash-wrapper
use bindings
use brew
use cliniko
use dinghy
use git-prompt
use n

# Use git prompt
le:prompt={ git-prompt:prompt }

# Disable right prompt
le:rprompt={ put '' }

# Autocompleter
le:completer[git]={ bash-wrapper:complete $@ }
