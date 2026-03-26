{
  keymaps = [
    # Aliasing the new leader ',' to the default one '\'
    {
      mode = "n";
      key = "<Bslash>";
      action = ",";
      options.remap = true;
    }

    # Better ESC
    {
      mode = "i";
      key = "jk";
      action = "<Esc>";
    }

    # Use sane regexes
    {
      mode = "n";
      key = "/";
      action = "/\\v";
    }
    {
      mode = "v";
      key = "/";
      action = "/\\v";
    }

    # Select the contents of the current line, excluding indentation.
    {
      mode = "n";
      key = "vv";
      action = "^vg_";
    }

    # Don't lose selection when shifting sidewards
    {
      mode = "x";
      key = "<";
      action = "<gv";
    }
    {
      mode = "x";
      key = ">";
      action = ">gv";
    }

    # Keep search matches in the middle of the window.
    {
      mode = "n";
      key = "n";
      action = "nzzzv";
    }
    {
      mode = "n";
      key = "N";
      action = "Nzzzv";
    }

    # Keep search matches when jumping around
    {
      mode = "n";
      key = "g;";
      action = "g;zz";
    }
    {
      mode = "n";
      key = "g,";
      action = "g,zz";
    }

    # It's 2021.
    {
      mode = "";
      key = "j";
      action = "gj";
    }
    {
      mode = "";
      key = "k";
      action = "gk";
    }
    {
      mode = "";
      key = "gj";
      action = "j";
    }
    {
      mode = "";
      key = "gk";
      action = "k";
    }

    # Better navigation between windows
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
    }

    # Make escape get out of pumenu mode and go back to the uncompleted word
    {
      mode = "i";
      key = "<Esc>";
      action = ''pumvisible() ? "<C-e>" : "<Esc>"'';
      options.expr = true;
    }

    # Sudo to write
    {
      mode = "c";
      key = "w!!";
      action = "w !sudo tee % >/dev/null";
    }

    # Open files in directory of current file
    {
      mode = "c";
      key = "%%";
      action = "<C-R>=expand('%:h').'/'<cr>";
    }
    {
      mode = "";
      key = "<leader>e";
      action = ":edit %%";
      options.remap = true;
    }

    # Find merge conflict markers
    {
      mode = "n";
      key = "<leader>cf";
      action = "<ESC>/\\v^[<=>]{7}( .*|$)<CR>";
      options.silent = true;
    }

    # Convert ruby 1.8 hash into ruby 1.9
    {
      mode = "n";
      key = "<leader>h";
      action = ":%s/:\\([^ ]*\\)\\(\\s*\\)=>/\\1:/g<CR>";
    }

    # Clean trailing whitespaces
    {
      mode = "n";
      key = "<leader>w";
      action = "mz:%s/\\s\\+$//<CR>:let @/=''<CR>`z";
    }

    # Edit .vimrc file
    {
      mode = "n";
      key = "<leader>EV";
      action = ":vsplit $MYVIMRC<cr>";
    }
    # Reload .vimrc file
    {
      mode = "n";
      key = "<leader>RV";
      action = ":source $MYVIMRC<cr>";
    }

    # Arrow keys are unacceptable
    {
      mode = "";
      key = "<Left>";
      action = '':echo "Arrow keys are unnaceptable"<CR>'';
      options.remap = true;
    }
    {
      mode = "";
      key = "<Right>";
      action = '':echo "Arrow keys are unnaceptable"<CR>'';
      options.remap = true;
    }
    {
      mode = "";
      key = "<Up>";
      action = '':echo "Arrow keys are unnaceptable"<CR>'';
      options.remap = true;
    }
    {
      mode = "";
      key = "<Down>";
      action = '':echo "Arrow keys are unnaceptable"<CR>'';
      options.remap = true;
    }
  ];

  # Clear the search buffer when hitting return
  keymapsOnEvents.CursorMoved = [
    {
      mode = "n";
      key = "<CR>";
      action.__raw = ''
        function()
          vim.cmd("nohlsearch")
          return "<CR>"
        end
      '';
      options = {
        noremap = true;
        silent = true;
        expr = true;
      };
    }
  ];

  # Typo commands
  userCommands = {
    E = {
      command = "e<bang>";
      bang = true;
    };
    Q = {
      command = "q<bang>";
      bang = true;
    };
    W = {
      command = "w<bang>";
      bang = true;
    };
    Qa = {
      command = "qa<bang>";
      bang = true;
    };
    QA = {
      command = "wa<bang>";
      bang = true;
    };
    Wa = {
      command = "wa<bang>";
      bang = true;
    };
    WA = {
      command = "wa<bang>";
      bang = true;
    };
    Wq = {
      command = "wq<bang>";
      bang = true;
    };
    WQ = {
      command = "wq<bang>";
      bang = true;
    };
  };

  # Keymaps that need lua functions
  extraConfigLua = ''
    -- Shortcut for setting a breakpoint
    vim.cmd("iabbrev xpry binding.break<Esc>F%s<c-o>:call getchar()<CR>")

    -- Rename current file
    vim.keymap.set("", "<leader>n", function()
      local old_name = vim.fn.expand("%")
      local new_name = vim.fn.input("New file name: ", vim.fn.expand("%"), "file")

      if new_name ~= "" and new_name ~= old_name then
        vim.cmd(":saveas " .. new_name)
        vim.cmd(":silent !rm " .. old_name)
        vim.cmd("redraw!")
      end
    end)

    -- Promote variable to rspec let
    vim.keymap.set("", "<leader>p", function()
      vim.cmd(":normal! dd")
      vim.cmd(":normal! P")
      vim.cmd(":.s/\\(\\w\\+\\) = \\(.*\\)$/let(:\\1) { \\2 }/")
      vim.cmd(":normal ==")
    end)
  '';
}
