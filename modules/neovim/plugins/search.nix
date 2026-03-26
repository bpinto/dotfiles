{ pkgs, ... }:

{
  plugins = {
    fzf-lua = {
      enable = true;

      lazyLoad.settings = {
        cmd = [ "FzfLua" ];
        keys = [
          {
            __unkeyed-1 = "<C-t>";
            __unkeyed-2.__raw = "function() require('fzf-lua').files() end";
            mode = "n";
            desc = "Find files";
          }
          {
            __unkeyed-1 = "<C-p>";
            __unkeyed-2.__raw = "function() require('fzf-lua').files() end";
            mode = "n";
            desc = "Find files";
          }
          {
            __unkeyed-1 = "<C-x>";
            __unkeyed-2.__raw = "function() require('fzf-lua').live_grep({ exec_empty_query = true }) end";
            mode = "n";
            desc = "Live grep";
          }
        ];
        after.__raw = ''
          function()
            require("fzf-lua").setup({
              defaults = {
                actions = {
                  ["ctrl-q"] = function(...)
                    return require("trouble.sources.fzf").actions.open(...)
                  end,
                },
              },
              files = {
                fzf_opts = {
                  ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-files-history",
                },
              },
              grep = {
                fzf_opts = {
                  ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-grep-history",
                },
                rg_glob = true,
              },
            })
          end
        '';
      };
    };

    trouble = {
      enable = true;
      lazyLoad.settings.cmd = [ "Trouble" ];
    };
  };

  keymaps = [
    # Trouble keymaps
    {
      mode = "n";
      key = "<leader>xx";
      action = "<cmd>Trouble diagnostics toggle<cr>";
      options.desc = "Diagnostics (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>xX";
      action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
      options.desc = "Buffer Diagnostics (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>cs";
      action = "<cmd>Trouble symbols toggle focus=false<cr>";
      options.desc = "Symbols (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>cl";
      action = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>";
      options.desc = "LSP Definitions / references / ... (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>xL";
      action = "<cmd>Trouble loclist toggle<cr>";
      options.desc = "Location List (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>xQ";
      action = "<cmd>Trouble qflist toggle<cr>";
      options.desc = "Quickfix List (Trouble)";
    }
  ];

}
