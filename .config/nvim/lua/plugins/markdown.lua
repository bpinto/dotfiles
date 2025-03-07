return {
	{
		"MeanderingProgrammer/markdown.nvim",
		cmd = { "RenderMarkdown" },
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		ft = { "gitcommit", "markdown" },
		main = "render-markdown",
		opts = {
			file_types = { "codecompanion", "gitcommit", "markdown" },
		},
	},
}
