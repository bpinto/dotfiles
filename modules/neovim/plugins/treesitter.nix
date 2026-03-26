{ pkgs, ... }:

{
  extraPlugins = with pkgs.vimPlugins; [
    nvim-treesitter-textsubjects
  ];

  plugins.lz-n.plugins = [
    {
      __unkeyed-1 = "nvim-treesitter-textsubjects";
      event = [ "DeferredUIEnter" ];
    }
  ];

  plugins = {
    treesitter = {
      enable = true;
      lazyLoad.settings.event = [ "DeferredUIEnter" ];

      settings = {
        highlight.enable = true;

        textobjects = {
          select = {
            enable = true;
            lookahead = true; # automatically jump forward to textobj

            keymaps = {
              "ab" = "@block.outer";
              "ib" = "@block.inner";
              "ac" = "@call.outer";
              "ic" = "@call.inner";
              "af" = "@function.outer";
              "if" = "@function.inner";
            };
          };

          move = {
            enable = true;
            set_jumps = true; # whether to set jumps in the jumplist

            goto_next_start = {
              "]m" = "@function.outer";
            };
            goto_next_end = {
              "]M" = "@function.outer";
            };
            goto_previous_start = {
              "[m" = "@function.outer";
            };
            goto_previous_end = {
              "[M" = "@function.outer";
            };
          };
        };

        textsubjects = {
          enable = true;
          keymaps = {
            "." = "textsubjects-smart";
            ";" = "textsubjects-container-outer";
          };
        };
      };

      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        comment
        css
        csv
        diff
        dockerfile
        fish
        git_config
        git_rebase
        gitcommit
        gitignore
        gotmpl
        helm
        html
        http
        javascript
        jsdoc
        json
        json5
        lua
        nix
        regex
        ruby
        scss
        sql
        ssh_config
        typescript
        yaml
      ];
    };

    treesitter-textobjects = {
      enable = true;
      lazyLoad.settings.event = [ "DeferredUIEnter" ];
    };
  };
}
