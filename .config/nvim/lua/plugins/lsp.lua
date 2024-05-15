return {
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		config = false,
		init = function()
			-- Disable automatic setup, we are doing it manually
			vim.g.lsp_zero_extend_cmp = 0
			vim.g.lsp_zero_extend_lspconfig = 0
		end,
	},
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = true,
	},

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"delphinus/cmp-ctags",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-emoji",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			-- Here is where you configure the autocompletion settings.
			local lsp_zero = require("lsp-zero")
			lsp_zero.extend_cmp()

			-- And you can configure cmp even more, if you want to.
			local cmp = require("cmp")
			local cmp_action = lsp_zero.cmp_action()

			cmp.setup({
				formatting = lsp_zero.cmp_format({ details = true }),
				mapping = cmp.mapping.preset.insert({
					["<Tab>"] = cmp_action.luasnip_supertab(),
					["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
				}),
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "ctags" },
					{ name = "emoji" },
				},
			})
		end,
	},

	-- LSP
	{
		"neovim/nvim-lspconfig",
		cmd = { "LspInfo", "LspInstall", "LspStart" },
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "williamboman/mason-lspconfig.nvim" },
		},
		config = function()
			-- This is where all the LSP shenanigans will live
			local lsp_zero = require("lsp-zero")
			lsp_zero.extend_lspconfig()

			-- Defines the sign icons that appear in the gutter.
			lsp_zero.set_sign_icons({
				error = "",
				warn = "",
				hint = "",
				info = "",
			})

			-- Disable autofocus on signature help
			vim.lsp.handlers["textDocument/signatureHelp"] =
				vim.lsp.with(vim.lsp.handlers.signature_help, { focus = false })

			--- if you want to know more about lsp-zero and mason.nvim
			--- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
			lsp_zero.on_attach(function(client, bufnr)
				if client.name == "eslint" then
					client.server_capabilities.documentFormattingProvider = true
				end

				vim.diagnostic.config({
					float = { border = "single", focus = false },
					signs = true,
					underline = true,
					update_in_insert = false, -- delay update diagnostics
					virtual_text = false, -- do not show diagnostics message inline
				})

				vim.opt.updatetime = 300 -- set inactivity time to 300ms

				-- see :help lsp-zero-keybindings
				-- to learn the available actions
				lsp_zero.default_keymaps({ buffer = bufnr })

				vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { buffer = bufnr })
				vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", { buffer = bufnr })

				-- Show line diagnostics after inactivity
				vim.cmd("autocmd CursorHold <buffer> lua vim.diagnostic.open_float()")

				-- Show signature help after inactivity on insertion mode
				vim.cmd("autocmd CursorHoldI <buffer> silent! lua vim.lsp.buf.signature_help()")
			end)

			require("mason-lspconfig").setup({
				ensure_installed = {
					"cssls",
					"dockerls",
					"docker_compose_language_service",
					"eslint",
					"html",
					"jsonls",
					"lua_ls",
					--"ruby_ls",
					"somesass_ls",
					"tsserver",
				},
				handlers = {
					lsp_zero.default_setup,
					lua_ls = function() -- Configure lua language server for neovim
						local lua_opts = lsp_zero.nvim_lua_ls()
						require("lspconfig").lua_ls.setup(lua_opts)
					end,
				},
			})
		end,
	},
}
