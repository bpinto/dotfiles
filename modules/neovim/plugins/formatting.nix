{ pkgs, ... }:

{
  plugins.conform-nvim = {
    enable = true;

    lazyLoad.settings = {
      event = [ "BufWritePre" ];
      cmd = [ "ConformInfo" ];
    };

    settings = {
      default_format_opts = {
        lsp_format = "fallback";
      };

      format_on_save = {
        timeout_ms = 500;
      };

      formatters_by_ft = {
        css = [ "prettierd" ];
        html = [ "prettierd" ];
        javascript = {
          "__unkeyed-1" = "prettierd";
          lsp_format = "first";
        };
        javascriptreact = {
          "__unkeyed-1" = "prettierd";
          lsp_format = "first";
        };
        json = [ "prettierd" ];
        markdown = [ "prettierd" ];
        yaml = [ "prettierd" ];
      };
    };
  };

  keymaps = [
    {
      mode = "";
      key = "<leader>f";
      action.__raw = ''
        function()
          require("conform").format({ async = true })
        end
      '';
      options.desc = "Format buffer";
    }
  ];

  extraConfigLua = ''
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  '';

  extraPackages = with pkgs; [
    prettierd
  ];
}
