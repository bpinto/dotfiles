return {
	{
		"tpope/vim-fugitive",
		event = "VeryLazy",
		keys = {
			{ -- Edit github pull request
				"<leader>EG",
				":execute 'split' fnameescape(FugitiveFind('.git/descriptions/'.fugitive#Head().'.markdown'))<CR>",
			},
		},
	},
}
