function console
    env TERM=xterm-256color ./infra/cli/index.mjs ssh $argv
end
