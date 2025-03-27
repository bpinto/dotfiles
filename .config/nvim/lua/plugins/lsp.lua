local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	if col == 0 then
		return false
	end

	local text = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
	return text:sub(col, col):match("%s") == nil
end

return {
	-- LSP
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = false,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		config = false,
	},
	{
		"neovim/nvim-lspconfig",
		cmd = { "LspInfo", "LspInstall", "LspStart" },
		dependencies = {
			"netmute/ctags-lsp.nvim",
		},
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("mason").setup({})
			require("mason-lspconfig").setup({
				ensure_installed = {
					"cssls",
					"dockerls",
					"docker_compose_language_service",
					"eslint",
					"helm_ls",
					"html",
					"jsonls",
					"lua_ls",
					-- "ruby_lsp",
					"somesass_ls",
					"ts_ls",
					"typos_lsp",
					"yamlls",
				},
			})

			require("lspconfig").ctags_lsp.setup({})
			require("lspconfig").cssls.setup({})
			require("lspconfig").dockerls.setup({})
			require("lspconfig").docker_compose_language_service.setup({})
			require("lspconfig").eslint.setup({
				on_attach = function(client)
					if client.name == "eslint" then
						client.server_capabilities.documentFormattingProvider = true
					elseif client.name == "tsserver" then
						client.server_capabilities.documentFormattingProvider = false
					end
				end,
			})
			require("lspconfig").helm_ls.setup({
				settings = {
					["helm-ls"] = {
						valuesFiles = {
							mainValuesFile = "values.yaml",
							additionalValuesFilesGlobPattern = "../../environment_values/development.yaml",
						},
					},
				},
			})
			require("lspconfig").html.setup({})
			require("lspconfig").jsonls.setup({})
			require("lspconfig").lua_ls.setup({
				on_init = function(client)
					if client.workspace_folders then
						local path = client.workspace_folders[1].name
						if
							path ~= vim.fn.stdpath("config")
							and (vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc"))
						then
							return
						end
					end

					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
						runtime = { version = "LuaJIT" },
						-- Make the server aware of Neovim runtime files
						workspace = {
							checkThirdParty = false,
							library = { vim.env.VIMRUNTIME },
						},
					})
				end,
				settings = {
					Lua = {},
				},
			})
			require("lspconfig").somesass_ls.setup({})
			require("lspconfig").ts_ls.setup({})
			require("lspconfig").typos_lsp.setup({})
			require("lspconfig").yamlls.setup({})

			vim.diagnostic.config({
				float = { border = "single", focus = false },
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.HINT] = "",
						[vim.diagnostic.severity.INFO] = "",
					},
				},
				underline = true,
				update_in_insert = false, -- delay update diagnostics
			})

			vim.opt.updatetime = 300 -- set inactivity time to 300ms

			-- Show line diagnostics after inactivity
			vim.api.nvim_create_autocmd({ "CursorHold" }, {
				pattern = "*",
				callback = function()
					-- Don't open diagnostic if floating dialog exists
					for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
						if vim.api.nvim_win_get_config(winid).zindex then
							return
						end
					end

					vim.diagnostic.open_float({
						close_events = {
							"CursorMoved",
							"CursorMovedI",
							"BufHidden",
							"InsertCharPre",
							"WinLeave",
						},
					})
				end,
			})
		end,

		keys = {
			{
				"gK",
				function()
					vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config().virtual_lines })
				end,
				mode = "n",
				desc = "Toggle diagnostic virtual_lines",
			},
		},
	},

	-- Completion
	{
		"saghen/blink.cmp",
		dependencies = {
			"moyiz/blink-emoji.nvim",
			{
				"Kaiser-Yang/blink-cmp-git",
				dependencies = { "nvim-lua/plenary.nvim" },
			},
		},
		event = "InsertEnter",
		version = "1.*",
		opts = {
			-- adjusts spacing to ensure icons are aligned
			appearance = { nerd_font_variant = "mono" },

			cmdline = {
				completion = {
					list = { selection = { preselect = false, auto_insert = true } },
					menu = { auto_show = true },
				},

				keymap = { preset = "default" },
			},

			completion = {
				-- Show documentation when selecting a completion item
				documentation = { auto_show = true, auto_show_delay_ms = 200 },

				list = { selection = { preselect = false, auto_insert = true } },

				trigger = {
					-- Shows after typing a trigger character, defined by the sources.
					show_on_trigger_character = true,
					-- Shows after entering insert mode on top of a trigger character.
					show_on_insert_on_trigger_character = true,
				},
			},

			fuzzy = { implementation = "prefer_rust_with_warning" },

			keymap = {
				preset = "default",

				["<CR>"] = { "accept", "select_and_accept", "fallback" },

				["<Tab>"] = {
					function(cmp)
						if has_words_before() then
							return cmp.insert_next()
						end
					end,
					"fallback",
				},
				["<S-Tab>"] = { "insert_prev" },
			},

			-- Experimental signature help support
			signature = { enabled = true },

			sources = {
				default = { "git", "lsp", "path", "snippets", "buffer", "emoji" },

				providers = {
					emoji = {
						module = "blink-emoji",
						name = "Emoji",
						score_offset = 15,
						should_show_items = function()
							return vim.tbl_contains(
								-- Enable emoji completion only for git commits and markdown.
								{ "gitcommit", "markdown" },
								vim.o.filetype
							)
						end,
					},

					git = { module = "blink-cmp-git", name = "Git" },
				},
			},
		},
		opts_extend = { "sources.default" },
	},
}
