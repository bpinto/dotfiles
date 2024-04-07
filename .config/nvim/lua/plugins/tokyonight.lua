return {
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = function()
      return {
        style = 'storm',

        on_highlights = function(hl, c)
          hl.CursorLineNr = { fg = c.orange, bold = true }
        end,
      }
    end,
  }
}
