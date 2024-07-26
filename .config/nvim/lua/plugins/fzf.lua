return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",
	keys = {
		-- <C-p> or <C-t> to search files
		{ "<C-t>", ":lua require('fzf-lua').files({ resume = true })<cr>", silent = true },
		{ "<C-p>", ":lua require('fzf-lua').files({ resume = true })<cr>", silent = true },
		-- <C-k> to search for a pattern
		{
			"<C-k>",
			":lua require('fzf-lua').live_grep({ exec_empty_query = true, resume = true  })<cr>",
			silent = true,
		},
	},
	config = function()
		local trouble_actions = require("trouble.sources.fzf").actions

		require("fzf-lua").setup({
			defaults = {
				actions = {
					["ctrl-q"] = trouble_actions.open,
				},
			},
			files = {
				fzf_opts = {
					["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-files-history",
				},
			},
			grep = {
				fzf_opts = {
					["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-grep-history",
				},
				rg_glob = true, -- enable glob parsing by default to all
			},
		})
	end,
}
