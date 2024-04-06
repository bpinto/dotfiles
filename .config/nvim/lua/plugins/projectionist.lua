return {
  {
    'tpope/vim-projectionist',
    event = 'VeryLazy',
    keys = {
      { '<leader>.', ':A<cr>' },
    },
    init = function()
      vim.g.projectionist_heuristics = vim.fn.json_decode(vim.fn.join(vim.fn.readfile(vim.fn.expand('~/.config/projections.json'))))
    end,
  }
}
