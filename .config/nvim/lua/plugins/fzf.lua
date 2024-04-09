return {
	{
		"junegunn/fzf",
		event = "VeryLazy",
		keys = {
			-- <C-p> or <C-t> to search files
			{ "<C-t>", ":FZF -m<cr>", silent = true },
			{ "<C-p>", ":FZF -m<cr>", silent = true },
		},
		init = function()
			-- Act like CtrlP
			vim.g.fzf_action = { ["ctrl-s"] = "split", ["ctrl-v"] = "vsplit" }
			-- Enable per-command history
			vim.g.fzf_history_dir = "~/.local/share/fzf-history"
			-- Show preview window with colors using bat
			vim.env.FZF_DEFAULT_OPTS =
				"--ansi --preview-window 'right:60%' --margin=1 --color=fg:#c0caf5,bg:#24283b,hl:#ff9e64 --color=fg+:#c0caf5,bg+:#292e42,hl+:#ff9e64 --color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a --preview 'bat --color=always --line-range :150 {}'"
		end,
	},
}
