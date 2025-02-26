return {
	"pwntester/octo.nvim",
	cmd = "Octo",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"ibhagwan/fzf-lua",
		"nvim-tree/nvim-web-devicons",
	},
	opts = function(_, opts)
		vim.treesitter.language.register("markdown", "octo")

		opts.default_delete_branch = true
		opts.default_merge_method = "squash"
		opts.default_to_projects_v2 = true
		opts.enable_builtin = true
		opts.picker = "fzf-lua"
		opts.user = "mentionable"
	end,
	keys = {
		{ "<leader>o", "<cmd>Octo<cr>", desc = "Octo" },
	},
}
