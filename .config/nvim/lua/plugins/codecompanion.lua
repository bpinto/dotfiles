return {
	{
		"github/copilot.vim",
		lazy = false, -- Load immediately
		config = function()
			-- Disable Copilot's default Tab mapping
			vim.g.copilot_no_tab_map = true

			-- Map <C-l> to accept Copilot suggestions
			vim.keymap.set("i", "<C-l>", 'copilot#Accept("<CR>")', {
				expr = true,
				silent = true,
				replace_keycodes = false,
				desc = "Accept Copilot suggestion",
			})
		end,
	},

	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"github/copilot.vim",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		init = function()
			vim.env["CODECOMPANION_TOKEN_PATH"] = vim.fn.expand("~/.config")
		end,
		lazy = false, -- Load immediately
		keys = {
			{
				"<leader>ac",
				"<cmd>CodeCompanionActions<cr>",
				mode = { "n", "v" },
				noremap = true,
				silent = true,
				desc = "CodeCompanion actions",
			},
			{
				"<leader>aa",
				"<cmd>CodeCompanionChat Toggle<cr>",
				mode = { "n", "v" },
				noremap = true,
				silent = true,
				desc = "CodeCompanion chat",
			},
			{
				"<leader>ad",
				"<cmd>CodeCompanionChat Add<cr>",
				mode = "v",
				noremap = true,
				silent = true,
				desc = "CodeCompanion add to chat",
			},
		},
		opts = {
			adapters = {
				copilot = function()
					return require("codecompanion.adapters").extend("copilot", {
						schema = {
							model = {
								default = "claude-3.7-sonnet",
							},
						},
					})
				end,
			},

			strategies = {
				chat = {
					slash_commands = {
						["buffer"] = {
							opts = {
								provider = "fzf_lua",
							},
						},
						["file"] = {
							opts = {
								provider = "fzf_lua",
							},
						},
						["help"] = {
							opts = {
								provider = "fzf_lua",
							},
						},
						["symbols"] = {
							opts = {
								provider = "fzf_lua",
							},
						},
					},
				},
			},

			opts = {
				--log_level = "DEBUG",
			},
		},
	},
}
