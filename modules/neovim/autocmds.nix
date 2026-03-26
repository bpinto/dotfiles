{
  autoCmd = [
    {
      desc = "Auto open the search result";
      event = [ "QuickFixCmdPost" ];
      pattern = [ "*grep*" ];
      command = "cwindow";
    }

    {
      desc = "Spell checking and automatic wrapping at the 72 chars to git commit message";
      event = [ "Filetype" ];
      pattern = [ "gitcommit" ];
      command = "setlocal spell textwidth=72";
    }

    {
      desc = ".slim is a slm filetype";
      event = [
        "BufNewFile"
        "BufRead"
      ];
      pattern = [ "*.slim" ];
      command = "set syntax=slm";
    }

    {
      desc = "Jump to last cursor position unless it's invalid or in an event handler";
      event = [ "BufReadPost" ];
      group = "cursor_position";
      callback.__raw = ''
        function()
          local line = vim.fn.line("'\"")
          if line > 0 and line <= vim.fn.line("$") then
            vim.cmd('normal! g`"')
          end
        end
      '';
    }

    {
      desc = "Highlight characters longer than 100 characters";
      event = [ "BufEnter" ];
      group = "highlight";
      callback.__raw = ''
        function()
          if vim.bo.buftype ~= "nofile" then
            vim.fn.matchadd("OverLength", "\\%>100v.\\+")
          end
        end
      '';
    }

    {
      desc = "Autosave files/buffers when losing focus";
      event = [ "FocusLost" ];
      group = "autosave";
      pattern = [ "*" ];
      command = "silent! wall";
    }

    {
      desc = "Show line diagnostics after inactivity";
      event = [ "CursorHold" ];
      pattern = [ "*" ];
      callback.__raw = ''
        function()
          for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.api.nvim_win_get_config(winid).zindex then
              return
            end
          end

          vim.diagnostic.open_float({
            close_events = {
              "CursorMoved",
              "CursorMovedI",
              "BufHidden",
              "InsertCharPre",
              "WinLeave",
            },
          })
        end
      '';
    }
  ];

  autoGroups = {
    autosave = {
      clear = true;
    };
    cursor_position = {
      clear = true;
    };
    highlight = {
      clear = true;
    };
  };
}
