{ pkgs, ... }:

{
  plugins = {
    lualine = {
      enable = true;

      lazyLoad.settings.event = [ "DeferredUIEnter" ];

      settings = {
        options = {
          theme = "tokyonight";
          component_separators = {
            left = "";
            right = "";
          };
          icons_enabled = true;
        };

        sections = {
          lualine_a = [
            {
              "__unkeyed-1" = "mode";
              upper = true;
            }
          ];
          lualine_b = [
            {
              "__unkeyed-1" = "branch";
              icon = "";
            }
          ];
          lualine_c = [
            {
              "__unkeyed-1" = "filename";
              file_status = true;
              path = 1;
            }
          ];
          lualine_x = [
            "encoding"
            "fileformat"
            {
              "__unkeyed-1" = "filetype";
              icon_only = true;
            }
          ];
          lualine_y = [ "progress" ];
          lualine_z = [ "location" ];
        };

        inactive_sections = {
          lualine_a = [ ];
          lualine_b = [ ];
          lualine_c = [
            {
              "__unkeyed-1" = "filename";
              file_status = true;
              path = 1;
            }
          ];
          lualine_x = [ "location" ];
          lualine_y = [ ];
          lualine_z = [ ];
        };

        tabline = { };
        extensions = [ ];
      };
    };

    package-info = {
      enable = true;

      lazyLoad.settings = {
        ft = [ "json" ];
      };

      settings = {
        hide_up_to_date = true;
      };
    };

    render-markdown = {
      enable = true;

      lazyLoad.settings = {
        cmd = [ "RenderMarkdown" ];
        ft = [
          "codecompanion"
          "markdown"
        ];
      };

      settings = {
        file_types = [
          "codecompanion"
          "markdown"
        ];
      };
    };

    web-devicons = {
      enable = true;
      lazyLoad.settings.event = [ "DeferredUIEnter" ];
    };
  };

  extraPlugins = with pkgs.vimPlugins; [
    nui-nvim
  ];
}
