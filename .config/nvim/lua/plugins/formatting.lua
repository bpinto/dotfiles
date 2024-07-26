return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		init = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
		opts = {
			default_format_opts = { lsp_format = "fallback" },
			format_on_save = { timeout_ms = 500 },
			formatters_by_ft = {
				css = { "prettierd" },
				html = { "prettierd" },
				javascript = { "prettierd", lsp_format = "first" },
				javascriptreact = { "prettierd", lsp_format = "first" },
				json = { "prettierd" },
				lua = { "stylua" },
				markdown = { "prettierd" },
				yaml = { "prettierd" },
			},
		},
	},
	-- Ensure installed binaries
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		lazy = false,
		opts = {
			ensure_installed = {
				"prettierd",
				"stylua",
			},
		},
	},
}
