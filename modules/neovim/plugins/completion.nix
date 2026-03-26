{ pkgs, ... }:

{
  plugins.blink-cmp = {
    enable = true;
    lazyLoad.settings.event = [ "InsertEnter" ];

    settings = {
      # adjusts spacing to ensure icons are aligned
      appearance.nerd_font_variant = "mono";

      cmdline = {
        completion = {
          list.selection = {
            preselect = false;
            auto_insert = true;
          };
          menu.auto_show = true;
        };
        keymap.preset = "default";
      };

      completion = {
        # Show documentation when selecting a completion item
        documentation = {
          auto_show = true;
          auto_show_delay_ms = 200;
        };
        list.selection = {
          preselect = false;
          auto_insert = true;
        };
        trigger = {
          show_on_trigger_character = true;
          show_on_insert_on_trigger_character = true;
        };
      };

      fuzzy.implementation = "prefer_rust_with_warning";

      keymap = {
        preset = "default";
        "<CR>" = [
          "accept"
          "select_and_accept"
          "fallback"
        ];
        "<Tab>" = [
          {
            "__raw" = ''
              function(cmp)
                local has_words_before = function()
                  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                  if col == 0 then return false end
                  local text = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
                  return text:sub(col, col):match("%s") == nil
                end

                if has_words_before() then
                  return cmp.insert_next()
                end
              end
            '';
          }
          "fallback"
        ];
        "<S-Tab>" = [ "insert_prev" ];
      };

      # Experimental signature help support
      signature.enabled = true;

      sources = {
        default = [
          "git"
          "lsp"
          "path"
          "snippets"
          "buffer"
          "emoji"
        ];

        providers = {
          emoji = {
            module = "blink-emoji";
            name = "Emoji";
            score_offset = 15;
            should_show_items.__raw = ''
              function()
                return vim.tbl_contains(
                  { "gitcommit", "markdown" },
                  vim.o.filetype
                )
              end
            '';
          };

          git = {
            module = "blink-cmp-git";
            name = "Git";
          };
        };
      };
    };
  };

  extraPlugins = with pkgs.vimPlugins; [
    blink-emoji-nvim
    blink-cmp-git
  ];
}
