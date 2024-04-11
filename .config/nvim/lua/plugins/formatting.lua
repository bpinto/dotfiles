local function get_lsp_fallback(bufnr)
	local always_use_lsp = vim.bo[bufnr].filetype:match("^javascript")
	return always_use_lsp and "always" or true
end

return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = get_lsp_fallback(0) })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		init = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
		opts = {
			format_on_save = function(bufnr)
				return {
					lsp_fallback = get_lsp_fallback(bufnr),
					timeout_ms = 500,
				}
			end,
			formatters_by_ft = {
				css = { "prettierd" },
				html = { "prettierd" },
				javascript = { "prettierd" },
				javascriptreact = { "prettierd" },
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
