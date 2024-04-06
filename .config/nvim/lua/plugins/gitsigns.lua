local keymap = vim.keymap

return {
  {
    'lewis6991/gitsigns.nvim',
    event = "VeryLazy",
    opts = {
      on_attach = function(bufnr)
        -- Navigation
        keymap.set('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
        keymap.set('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

        -- Actions
        keymap.set('n', '<leader>hs', ':Gitsigns stage_hunk<CR>')
        keymap.set('v', '<leader>hs', ':Gitsigns stage_hunk<CR>')
        keymap.set('n', '<leader>hr', ':Gitsigns reset_hunk<CR>')
        keymap.set('v', '<leader>hr', ':Gitsigns reset_hunk<CR>')
        keymap.set('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>')
        keymap.set('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>')
        keymap.set('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>')
        keymap.set('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>')
        keymap.set('n', '<leader>hb', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
        keymap.set('n', '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<CR>')
        keymap.set('n', '<leader>hd', '<cmd>Gitsigns diffthis<CR>')
        keymap.set('n', '<leader>hD', '<cmd>lua require"gitsigns".diffthis("~")<CR>')
        keymap.set('n', '<leader>td', '<cmd>Gitsigns toggle_deleted<CR>')

        -- Text object
        keymap.set('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        keymap.set('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end
    }
  }
}
