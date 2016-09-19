le:binding[insert][Ctrl-L]={ clear > /dev/tty }   # Set usual shortcut to clear terminal
le:binding[insert][Ctrl-N]={ le:start-location }  # Set start location shortcut
le:binding[insert][Alt-l]={ le:start-nav }        # Set start navigation shortcut
le:binding[completion][Shift-Tab]={ le:compl-up } # Add missing Shift-Tab shortcut

# Emacs keybinding
le:binding[insert][Ctrl-A]={ le:move-dot-sol }
le:binding[insert][Ctrl-E]={ le:move-dot-eol }
le:binding[insert][Ctrl-B]={ le:move-dot-left-word }
le:binding[insert][Ctrl-F]={ le:move-dot-right-word }
