return {
  {
    'tpope/vim-rhubarb',
    dependencies = { 'ervandew/supertab' },
    event = 'VeryLazy',
    config = function()
      vim.cmd([[
        augroup config-github-complete
        " Remove ALL autocommands for the current group.
        autocmd!

        " Github completion on git commit messages
        autocmd FileType gitcommit setl omnifunc=rhubarb#omnifunc | call SuperTabChain(&omnifunc, "<c-p>")
        augroup END
      ]])
    end,
  }
}

