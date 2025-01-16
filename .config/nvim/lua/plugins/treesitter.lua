return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			"RRethy/nvim-treesitter-textsubjects",
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		event = "VeryLazy",
		config = function()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = {
					"bash",
					"comment",
					"css",
					"csv",
					"diff",
					"dockerfile",
					"fish",
					"git_config",
					"git_rebase",
					"gitcommit",
					"gitignore",
					"gotmpl",
					"helm",
					"html",
					"http",
					"javascript",
					"jsdoc",
					"json",
					"json5",
					"lua",
					"regex",
					"ruby",
					"scss",
					"sql",
					"ssh_config",
					"typescript",
					"yaml",
				},

				highlight = {
					enable = true, -- enable extension
				},

				-- Treesitter textobjects
				textobjects = {
					select = {
						enable = true,
						lookahead = true, -- automatically jump forward to textobj

						keymaps = {
							["ab"] = "@block.outer",
							["ib"] = "@block.inner",
							["ac"] = "@call.outer",
							["ic"] = "@call.inner",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
						},
					},

					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist

						goto_next_start = {
							["]m"] = "@function.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
						},
					},
				},

				-- Treesitter textsubjects
				textsubjects = {
					enable = true,
					keymaps = {
						["."] = "textsubjects-smart",
						[";"] = "textsubjects-container-outer",
					},
				},
			})
		end,
	},
}
