
return {
  {
    'tpope/vim-fugitive',
    event = 'VeryLazy',
    keys = {
      { '<leader>EG', ":execute 'split' fnameescape(FugitiveFind('.git/descriptions/'.fugitive#Head().'.mk'))<CR>" },
    },
  }
}

