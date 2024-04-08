return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	event = { "BufReadPre", "BufReadPost", "BufNewFile" },
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				-- code actions
				null_ls.builtins.code_actions.gitsigns,

				-- diagnostics
				null_ls.builtins.diagnostics.codespell,
			},
		})
	end,
}
