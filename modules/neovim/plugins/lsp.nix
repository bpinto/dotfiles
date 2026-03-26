{ pkgs, ... }:

{
  plugins.lsp = {
    enable = true;
    lazyLoad.settings.event = [
      "BufReadPre"
      "BufNewFile"
    ];

    servers = {
      cssls.enable = true;
      dockerls.enable = true;
      docker_compose_language_service.enable = true;
      eslint.enable = true;
      helm_ls = {
        enable = true;
        settings = {
          "helm-ls" = {
            valuesFiles = {
              mainValuesFile = "values.yaml";
              additionalValuesFilesGlobPattern = "../../environment_values/development.yaml";
            };
          };
        };
      };
      html.enable = true;
      jsonls.enable = true;
      ts_ls.enable = true;
      typos_lsp.enable = true;
      yamlls.enable = true;
    };
  };

  plugins.helm.enable = true;

  keymaps = [
    {
      mode = "n";
      key = "gK";
      action.__raw = ''
        function()
          vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config().virtual_lines })
        end
      '';
      options.desc = "Toggle diagnostic virtual_lines";
    }
  ];

  plugins.lz-n.plugins = [
    {
      __unkeyed-1 = "helm-ls.nvim";
      ft = [ "helm" ];
      after.__raw = ''
        function()
          require("helm-ls").setup({
            conceal_templates = {
              enabled = false,
            },
            indent_hints = {
              enabled = true,
              only_for_current_line = true,
            },
          })
        end
      '';
    }
  ];

  extraPlugins = with pkgs.vimPlugins; [
    helm-ls-nvim
  ];

  extraConfigLua = ''
    vim.lsp.config("ctags_lsp", {
      cmd = { "ctags-lsp" },
      root_dir = vim.uv.cwd(),
    })
    vim.lsp.enable("ctags_lsp")
  '';

  extraPackages = with pkgs; [
    ctags-lsp
  ];
}
