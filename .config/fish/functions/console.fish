function console
    env TERM=xterm-256color rgi ssh --preserve-current-context --quiet $argv
end
