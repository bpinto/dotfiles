function console
    env TERM=xterm-256color rgi ssh --preserve-current-context $argv
end
