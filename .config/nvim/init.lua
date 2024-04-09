local cmd = vim.cmd
local fn = vim.fn
local keymap = vim.keymap
local opt = vim.opt

--------------------------------------------------------------------------------
-- PLUGINS
--------------------------------------------------------------------------------
-- Enable the experimental Lua module loader
if vim.loader then
	vim.loader.enable()
end

-- lazy.nvim requires this to be defined before its setup
-- Remapping leader to ,
vim.g.mapleader = ","

-- Bootstrap lazy.nvim
local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
opt.rtp:prepend(lazypath)

-- Configure lazy.nvim
require("lazy").setup({
	{ import = "plugins" }, -- Merge with configurations from ~/.config/nvim/lua/plugins/*.lua
	{ "jbmorgado/vim-pine-script", ft = "pine" },
	{ "slm-lang/vim-slm", event = "VeryLazy" },
	{ "tpope/vim-surround", event = "VeryLazy" },
}, {
	defaults = { lazy = true },
	install = { colorscheme = { "tokyonight", "habamax" } },
})

--------------------------------------------------------------------------------
-- EDITOR CONFIGURATION
--------------------------------------------------------------------------------

opt.autowrite = true -- Write the contents of the file if it has been modified
opt.switchbuf = "useopen" -- Use already open buffer

--------------------------------------------------------------------------------
-- INTERFACE
--------------------------------------------------------------------------------

cmd("syntax enable") -- Enable highlighting for syntax
opt.synmaxcol = 128 -- Syntax coloring lines that are too long just slows down the world

opt.cmdheight = 2 -- Height of the command bar
opt.cursorline = true -- Highlight current line
opt.foldmethod = "manual" -- Fix vim auto-complete slowness in large projects
opt.lazyredraw = true -- To avoid scrolling problems
opt.number = true -- Show line numbers
opt.numberwidth = 5 -- Line number left margin
opt.scrolloff = 3 -- Keep more context when scrolling off the end of a buffer (3 lines)
opt.showcmd = true -- Display incomplete commands
opt.splitbelow = true -- When on, splitting a window will put the new window below the current one
opt.splitright = true -- When on, splitting a window will put the new window right of the current one
opt.title = true -- Set window title
opt.winwidth = 79 -- Minimal window width

--------------------------------------------------------------------------------
-- COLOR
--------------------------------------------------------------------------------
opt.background = "dark" -- background color
opt.termguicolors = true -- enable true colors in the terminal

cmd("colorscheme tokyonight")

--vim.api.nvim_set_hl(0, 'VertSplit', {
--fg = '#343F4C',
--bg = 'NONE',
--ctermfg = 81,
--ctermbg = 'NONE',
--})

--------------------------------------------------------------------------------
-- SEARCH CONFIGURATION
--------------------------------------------------------------------------------
opt.showmatch = true -- Show matching bracket when text indicator is over them
opt.tags:append(".git/tags") -- Add ctags stored on .git folder to search list

-- Make searches case-sensitive only if they contain upper-case characters
opt.ignorecase = true
opt.smartcase = true

--------------------------------------------------------------------------------
-- BACKUP
--------------------------------------------------------------------------------

opt.backup = true -- Enable backups
opt.backupdir = vim.fn.expand("~/.local/share/nvim/backup/")
opt.backupskip = { "/tmp/*", "/private/tmp/*" } -- Make vim able to edit crontab files again
opt.swapfile = false -- It's 2021, Vim.
opt.undofile = true -- Enable undo history
opt.undodir = vim.fn.expand("~/.local/share/nvim/undo/")

--------------------------------------------------------------------------------
-- INDENTATION
--------------------------------------------------------------------------------

-- Enable file type detection.
-- Also load indent files, to automatically do language-dependent indenting.
cmd("filetype plugin indent on")
opt.expandtab = true -- Use spaces, not tabs
opt.tabstop = 2 -- A tab is two spaces
opt.shiftwidth = 2 -- An autoindent (with <<) is two spaces
opt.softtabstop = 2 -- Should be the same value of shiftwidth
opt.shiftround = true -- Always round the indent to a multiple of 'shiftwidth'
vim.g.do_filetype_lua = 1 -- Activate the Lua filetype detection mechanism
vim.g.did_load_filetypes = 0 -- Disable filetype.vim detection mechanism

--------------------------------------------------------------------------------
-- WILDMENU
--------------------------------------------------------------------------------

-- Use emacs-style tab completion when selecting files, etc
opt.wildmode = { "longest", "list" }

opt.wildignore:append({ ".hg", ".git", ".svn" }) -- Version control
opt.wildignore:append({ "*.orig" }) -- Merge resolution files

opt.wildignore:append({ "*.aux", "*.out", "*.toc" }) -- LaTeX intermediate files
opt.wildignore:append({ "*.bmp", "*.gif", "*.jpg", "*.jpeg", "*.png" }) -- Binary images
opt.wildignore:append({ "*.sw?" }) -- Vim swap files
opt.wildignore:append({ "*.DS_Store" }) -- OSX bullshit
opt.wildignore:append({ "*/cassettes/**/*.yml" }) -- Ruby VCR
opt.wildignore:append({ "*/tmp/**" })
opt.wildignore:append({ "*/vendor/bundle" }) -- Cached ruby gems

--------------------------------------------------------------------------------
-- LIST
--------------------------------------------------------------------------------

-- A tab should display as spaces
-- A trailing whitespace as "."
-- The character to show when wrap is off and the line continues beyond the screen as "…"
opt.list = true -- Show invisible characters
opt.listchars = { extends = "…", precedes = "…", tab = "  ", trail = "·" }

--------------------------------------------------------------------------------
-- CONVENIENCE MAPPINGS
--------------------------------------------------------------------------------

-- Remapping leader to ,
vim.g.mapleader = ","

-- Aliasing the new leader ',' to the default one '\'
keymap.set("n", "<Bslash>", ",", { remap = true })

-- Better ESC
keymap.set("i", "jk", "<Esc>")

-- Use sane regexes
keymap.set("n", "/", "/\\v")
keymap.set("v", "/", "/\\v")

-- Select the contents of the current line, excluding indentation.
keymap.set("n", "vv", "^vg_")

-- Don't lose selection when shifting sidewards
keymap.set("x", "<", "<gv")
keymap.set("x", ">", ">gv")

-- Keep search matches in the middle of the window.
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")
-- Same when jumping around
keymap.set("n", "g;", "g;zz")
keymap.set("n", "g,", "g,zz")

-- It's 2021.
keymap.set("", "j", "gj")
keymap.set("", "k", "gk")
keymap.set("", "gj", "j")
keymap.set("", "gk", "k")

-- Better navigation between windows
keymap.set("n", "<C-h>", "<C-w>h")
keymap.set("n", "<C-j>", "<C-w>j")
keymap.set("n", "<C-k>", "<C-w>k")
keymap.set("n", "<C-l>", "<C-w>l")

-- Clear the search buffer when hitting return
function _G.map_enter()
	keymap.set("n", "<cr>", ":nohlsearch<cr>:call clearmatches()<cr>")
end
_G.map_enter()

-- Make escape get out of pumenu mode and go back to the uncompleted word
keymap.set("i", "<Esc>", 'pumvisible() ? "<C-e>" : "<Esc>"', { expr = true })

-- Typos
vim.api.nvim_create_user_command("E", "e<bang>", { bang = true })
vim.api.nvim_create_user_command("Q", "q<bang>", { bang = true })
vim.api.nvim_create_user_command("W", "w<bang>", { bang = true })
vim.api.nvim_create_user_command("Qa", "qa<bang>", { bang = true })
vim.api.nvim_create_user_command("QA", "wa<bang>", { bang = true })
vim.api.nvim_create_user_command("Wa", "wa<bang>", { bang = true })
vim.api.nvim_create_user_command("WA", "wa<bang>", { bang = true })
vim.api.nvim_create_user_command("Wq", "wq<bang>", { bang = true })
vim.api.nvim_create_user_command("WQ", "wq<bang>", { bang = true })

--------------------------------------------------------------------------------
-- EXTRA
--------------------------------------------------------------------------------

-- Sudo to write
keymap.set("c", "w!!", "w !sudo tee % >/dev/null")

-- Open files in directory of current file
keymap.set("c", "%%", "<C-R>=expand('%:h').'/'<cr>")
keymap.set("", "<leader>e", ":edit %%", { remap = true })

-- Find merge conflict markers
keymap.set("n", "<leader>cf", "<ESC>/\\v^[<=>]{7}( .*|$)<CR>", { silent = true })

-- Shortcut for setting a pry breakpoint
cmd("iabbrev xpry require 'pry'; binding.pry<Esc>F%s<c-o>:call getchar()<CR>")

-- Convert ruby 1.8 hash into ruby 1.9
keymap.set("n", "<leader>h", ":%s/:\\([^ ]*\\)\\(\\s*\\)=>/\\1:/g<CR>")

-- Clean trailing whitespaces
keymap.set("n", "<leader>w", "mz:%s/\\s\\+$//<CR>:let @/=''<CR>`z")

-- Edit .vimrc file
keymap.set("n", "<leader>EV", ":vsplit $MYVIMRC<cr>")

-- Reload .vimrc file
keymap.set("n", "<leader>RV", ":source $MYVIMRC<cr>")

-- Edit elvish config file
keymap.set("n", "<leader>EE", ":vsplit ~/.elvish/rc.elv<cr>")

-- Edit fish config file
keymap.set("n", "<leader>EF", ":vsplit ~/.config/fish/config.fish<cr>")

-- Edit github pull request
keymap.set(
	"n",
	"<leader>EG",
	":execute 'split' fnameescape(FugitiveFind('.git/descriptions/'.fugitive#Head().'.mk'))<CR>"
)

-- Edit tmux config file
keymap.set("n", "<leader>ET", ":vsplit ~/.tmux.conf<cr>")

-- Replace grep with ripgrep
if vim.fn.executable("rg") == 1 then
	opt.grepprg = "rg --vimgrep"
end

-- Auto open the search result
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	pattern = "*grep*",
	callback = function()
		cmd("cwindow")
	end,
	desc = "Auto open the search result",
})

-- Spell checking and automatic wrapping at the 72 chars to git commit message
vim.api.nvim_create_autocmd("Filetype", {
	pattern = "gitcommit",
	callback = function()
		cmd("setlocal spell textwidth=72")
	end,
	desc = "Spell checking and automatic wrapping at the 72 chars to git commit message",
})

-- .slim is a slm filetype
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.slim",
	callback = function()
		cmd("set syntax=slm")
	end,
	desc = ".slim is a slm filetype",
})

-- .pine is a psl filetype
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.pine",
	callback = function()
		cmd("set filetype=pine")
		cmd("set syntax=psl")
	end,
	desc = ".pine is a psl filetype",
})

--------------------------------------------------------------------------------
-- ARROW KEYS ARE UNACCEPTABLE
--------------------------------------------------------------------------------

keymap.set("", "<Left>", ':echo "Arrow keys are unnaceptable"<CR>', { remap = true })
keymap.set("", "<Right>", ':echo "Arrow keys are unnaceptable"<CR>', { remap = true })
keymap.set("", "<Up>", ':echo "Arrow keys are unnaceptable"<CR>', { remap = true })
keymap.set("", "<Down>", ':echo "Arrow keys are unnaceptable"<CR>', { remap = true })

--------------------------------------------------------------------------------
-- RENAME CURRENT FILE
--------------------------------------------------------------------------------

keymap.set("", "<leader>n", function()
	local old_name = fn.expand("%")
	local new_name = fn.input("New file name: ", vim.fn.expand("%"), "file")

	if new_name ~= "" and new_name ~= old_name then
		cmd(":saveas " .. new_name)
		cmd(":silent !rm " .. old_name)
		cmd("redraw!")
	end
end)

--------------------------------------------------------------------------------
-- PROMOTE VARIABLE TO RSPEC LET
--------------------------------------------------------------------------------

keymap.set("", "<leader>p", function()
	cmd(":normal! dd")
	cmd(":normal! P")
	cmd(":.s/\\(\\w\\+\\) = \\(.*\\)$/let(:\\1) { \\2 }/")
	cmd(":normal ==")
end)

--------------------------------------------------------------------------------
-- CUSTOM AUTOCMDS
--------------------------------------------------------------------------------

cmd([[
  augroup cursor-position
    " Remove ALL autocommands for the current group.
    autocmd!

    " Jump to last cursor position unless it's invalid or in an event handler
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
  augroup END
]])

cmd([[
  augroup highlight
    " Remove ALL autocommands for the current group.
    autocmd!

    " Leave the return key alone when in quickfix windows, since it's used
    " to run commands there.
    autocmd BufEnter * :if &buftype is# "quickfix" | :unmap <cr> | else | :call v:lua.map_enter() | endif

    " Leave the return key alone when in command line windows, since it's used
    " to run commands there.
    autocmd CmdwinEnter * :unmap <cr>
    autocmd CmdwinLeave * :call v:lua.map_enter()

    " Highlight characters longer than 100 characters
    autocmd BufEnter * highlight OverLength ctermbg=grey guibg=#2E3C64
    autocmd BufEnter * :if &buftype isnot# "nofile" | match OverLength /\%>100v.\+/ | endif
  augroup END
]])

cmd([[
  augroup autosave
    " Remove ALL autocommands for the current group.
    autocmd!

    " Autosave files/buffers when losing focus
    autocmd FocusLost * :silent! wall
  augroup END
]])
