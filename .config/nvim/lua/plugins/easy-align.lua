return {
	{
		"tpope/vim-projectionist",
		event = "VeryLazy",
		keys = {
			-- Start interactive EasyAlign for a motion/text object (e.g. gaip)
			{ "ga", "<Plug>(EasyAlign)", remap = true },
			-- Start interactive EasyAlign in visual mode (e.g. vipga)
			{ "ga", "<Plug>(EasyAlign)", mode = "x", remap = true },
		},
	},
}
