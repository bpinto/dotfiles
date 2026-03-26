{ pkgs, ... }:

{
  # CodeCompanion requires the file provider
  extraPackages = [ pkgs.file ];

  plugins.copilot-vim = {
    enable = true;

    settings.no_tab_map = true;
  };

  plugins.lz-n.plugins = [
    {
      __unkeyed-1 = "copilot.vim";
      event = [ "InsertEnter" ];
    }
  ];

  plugins.codecompanion = {
    enable = true;

    lazyLoad.settings = {
      cmd = [
        "CodeCompanionChat"
        "CodeCompanionActions"
        "CodeCompanion"
      ];
      event = [ "InsertEnter" ];
      keys = [
        {
          __unkeyed-1 = "<leader>ac";
          mode = "n";
        }
        {
          __unkeyed-1 = "<leader>aa";
          mode = "n";
        }
        {
          __unkeyed-1 = "<leader>ad";
          mode = "v";
        }
      ];
    };

    settings = {
      adapters.http = {
        copilot.__raw = ''
          function()
            -- Ensure the copilot plugin is loaded before we extend its adapter
            pcall(vim.cmd, "packadd copilot.vim")

            return require("codecompanion.adapters").extend("copilot", {
              schema = {
                model = {
                  default = "gpt-5-mini",
                },
              },
            })
          end
        '';
      };

      strategies = {
        agent = {
          adapter = "copilot";
        };

        chat = {
          adapter = "copilot";
          slash_commands = {
            buffer = {
              opts.provider = "fzf_lua";
            };
            file = {
              opts.provider = "fzf_lua";
            };
            help = {
              opts.provider = "fzf_lua";
            };
            symbols = {
              opts.provider = "fzf_lua";
            };
          };
        };

        inline = {
          adapter = "copilot";
          keymaps = {
            accept_change = {
              modes.n = "ga";
              description = "Accept the suggested change";
            };
            reject_change = {
              modes.n = "gr";
              description = "Reject the suggested change";
            };
          };
        };
      };
    };
  };

  keymaps = [
    # Accept Copilot suggestions
    {
      mode = "i";
      key = "<C-l>";
      action = ''copilot#Accept("<CR>")'';
      options = {
        expr = true;
        silent = true;
        replace_keycodes = false;
        desc = "Accept Copilot suggestion";
      };
    }

    # CodeCompanion
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>ac";
      action = "<cmd>CodeCompanionActions<cr>";
      options = {
        noremap = true;
        silent = true;
        desc = "CodeCompanion actions";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>aa";
      action = "<cmd>CodeCompanionChat Toggle<cr>";
      options = {
        noremap = true;
        silent = true;
        desc = "CodeCompanion chat";
      };
    }
    {
      mode = "v";
      key = "<leader>ad";
      action = "<cmd>CodeCompanionChat Add<cr>";
      options = {
        noremap = true;
        silent = true;
        desc = "CodeCompanion add to chat";
      };
    }
  ];

  extraConfigLua = ''
    vim.env["CODECOMPANION_TOKEN_PATH"] = vim.fn.expand("~/.config")
  '';
}
