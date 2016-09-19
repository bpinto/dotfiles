if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

if [ -f /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash ]; then
  . /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash
fi
