return {
	{
		"scrooloose/nerdcommenter",
		event = "VeryLazy",
		keys = {
			{ "<leader>/", "<plug>NERDCommenterToggle<CR>", mode = "", remap = true },
			{ "<leader>/", "<Esc><plug>NERDCommenterToggle<CR>i", mode = "i", remap = true },
		},
		init = function()
			-- Do not create default mappings
			vim.g.NERDCreateDefaultMappings = 0
		end,
	},
}
