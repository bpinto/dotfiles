return {
  {
    'junegunn/fzf',
    event = 'VeryLazy',
    keys = {
      -- <C-p> or <C-t> to search files
      { '<C-t>', ':FZF -m<cr>', silent = true },
      { '<C-p>', ':FZF -m<cr>', silent = true },
    },
    init = function()
      -- Act like CtrlP
      vim.g.fzf_action = { ['ctrl-s'] = 'split', ['ctrl-v'] = 'vsplit' }
      -- Enable per-command history
      vim.g.fzf_history_dir = '~/.local/share/fzf-history'
      -- Show preview window with colors using bat
      vim.env.FZF_DEFAULT_OPTS = "--ansi --preview-window 'right:60%' --margin=1 --preview 'bat --color=always --line-range :150 {}'"
    end
  }
}
