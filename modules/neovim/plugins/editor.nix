{ pkgs, ... }:

let
  undotree-lua = pkgs.vimUtils.buildVimPlugin {
    pname = "undotree-lua";
    version = "unstable";
    src = pkgs.fetchFromGitHub {
      owner = "jiaoshijie";
      repo = "undotree";
      rev = "main";
      hash = "sha256-uVbH5V1rvNlSiiGNb7CojdeeCx9yBqOWY5+lq7yJTHo=";
    };
  };

  vim-slm = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-slm";
    version = "unstable";
    src = pkgs.fetchFromGitHub {
      owner = "slm-lang";
      repo = "vim-slm";
      rev = "master";
      hash = "sha256-olGfKghGFLFtFFbzmVgnzTyLdMXNCruUI8V9pPli3Jw=";
    };
  };
in
{
  plugins.vim-surround.enable = true;

  plugins.lz-n.plugins = [
    {
      __unkeyed-1 = "vim-surround";
      event = [ "DeferredUIEnter" ];
    }
    {
      __unkeyed-1 = "nerdcommenter";
      keys = [
        {
          __unkeyed-1 = "<leader>/";
          mode = [
            ""
            "i"
          ];
        }
      ];
      after.__raw = ''
        function()
          -- Do not create default mappings
          vim.g.NERDCreateDefaultMappings = 0
        end
      '';
    }
    {
      __unkeyed-1 = "vim-projectionist";
      event = [ "DeferredUIEnter" ];
      after.__raw = ''
        function()
          vim.g.projectionist_heuristics =
            vim.fn.json_decode(vim.fn.join(vim.fn.readfile(vim.fn.expand("~/.config/projections.json"))))
        end
      '';
    }
    {
      __unkeyed-1 = "undotree-lua";
      keys = [
        {
          __unkeyed-1 = "<leader>u";
          __unkeyed-2 = "<cmd>lua require('undotree').toggle()<cr>";
        }
      ];
      after.__raw = ''
        function()
          require("undotree").setup()
        end
      '';
    }
    {
      __unkeyed-1 = "vim-slm";
      ft = [ "slm" ];
    }
  ];

  keymaps = [
    # EasyAlign - Start interactive EasyAlign for a motion/text object (e.g. gaip)
    {
      mode = "n";
      key = "ga";
      action = "<Plug>(EasyAlign)";
      options.remap = true;
    }
    # EasyAlign - Start interactive EasyAlign in visual mode (e.g. vipga)
    {
      mode = "x";
      key = "ga";
      action = "<Plug>(EasyAlign)";
      options.remap = true;
    }

    # NERDCommenter
    {
      mode = "";
      key = "<leader>/";
      action = "<plug>NERDCommenterToggle<CR>";
      options.remap = true;
    }
    {
      mode = "i";
      key = "<leader>/";
      action = "<Esc><plug>NERDCommenterToggle<CR>i";
      options.remap = true;
    }

    # Projectionist
    {
      mode = "n";
      key = "<leader>.";
      action = ":A<cr>";
    }
  ];

  extraPlugins = [
    pkgs.vimPlugins.nerdcommenter
    pkgs.vimPlugins.vim-projectionist
    undotree-lua
    vim-slm
  ];
}
