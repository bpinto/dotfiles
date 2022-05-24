local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local opt = vim.opt  -- to set options

--------------------------------------------------------------------------------
-- PLUGINS
--------------------------------------------------------------------------------

require 'paq' {
  'savq/paq-nvim'; -- paq-nvim manages itself
  'MunifTanjim/nui.nvim'; -- required by package-info
  'RRethy/nvim-treesitter-textsubjects';
  'eddyekofo94/gruvbox-flat.nvim';
  'ervandew/supertab';
  'folke/trouble.nvim';
  'ful1e5/onedark.nvim';
  'hoob3rt/lualine.nvim';
  'hrsh7th/cmp-buffer';
  'hrsh7th/cmp-emoji';
  'hrsh7th/cmp-nvim-lsp';
  'hrsh7th/nvim-cmp';
  'jose-elias-alvarez/null-ls.nvim';
  'junegunn/fzf';
  'junegunn/vim-easy-align';
  'lewis6991/gitsigns.nvim';
  'neovim/nvim-lspconfig';
  'nvim-lua/plenary.nvim'; -- required by: null-ls
  { 'nvim-treesitter/nvim-treesitter', run = function() vim.cmd('TSUpdate') end };
  'nvim-treesitter/nvim-treesitter-textobjects';
  'quangnguyen30192/cmp-nvim-tags';
  'scrooloose/nerdcommenter';
  'slm-lang/vim-slm';
  'tpope/vim-fugitive';
  'tpope/vim-projectionist';
  'tpope/vim-rhubarb';
  'tpope/vim-surround';
  'vuki656/package-info.nvim';
}

--------------------------------------------------------------------------------
-- EDITOR CONFIGURATION
--------------------------------------------------------------------------------

opt.autowrite = true -- Write the contents of the file if it has been modified
opt.switchbuf = 'useopen' -- Use already open buffer

--------------------------------------------------------------------------------
-- INTERFACE
--------------------------------------------------------------------------------

cmd 'syntax enable' -- Enable highlighting for syntax
opt.synmaxcol = 128 -- Syntax coloring lines that are too long just slows down the world

opt.cmdheight = 2 -- Height of the command bar
opt.cursorline = true -- Highlight current line
opt.foldmethod = 'manual' -- Fix vim auto-complete slowness in large projects
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
require('lualine').setup {
    options = {
        theme = 'gruvbox-flat',
        component_separators = {'', ''},
        icons_enabled = true
    },
    sections = {
        lualine_a = {{'mode', upper = true}},
        lualine_b = {{'branch', icon = ''}},
        lualine_c = {{'filename', file_status = true, path = 1}},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {{'filename', file_status = true, path = 1}},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    extensions = {}
}

vim.g.gruvbox_flat_style = "dark"
cmd 'colorscheme gruvbox-flat' -- Theme
opt.background = 'dark' -- Background color
opt.termguicolors = true -- Enable true colors in the terminal

-- More information, e.g. :verbose highlight, :verbose highlight VertSplit
cmd 'highlight VertSplit ctermfg=81 guifg=#343F4C ctermbg=none guibg=none' -- Color border

--------------------------------------------------------------------------------
-- SEARCH CONFIGURATION
--------------------------------------------------------------------------------
opt.showmatch = true -- Show matching bracket when text indicator is over them
opt.tags:append('.git/tags') -- Add ctags stored on .git folder to search list

-- Make searches case-sensitive only if they contain upper-case characters
opt.ignorecase = true
opt.smartcase = true

--------------------------------------------------------------------------------
-- BACKUP
--------------------------------------------------------------------------------

opt.backup = true -- Enable backups
opt.backupdir = vim.fn.expand("~/.local/share/nvim/backup/")
opt.backupskip = { '/tmp/*', '/private/tmp/*' } -- Make vim able to edit crontab files again
opt.swapfile = false -- It's 2021, Vim.
opt.undofile = true -- Enable undo history
opt.undodir = vim.fn.expand("~/.local/share/nvim/undo/")

--------------------------------------------------------------------------------
-- INDENTATION
--------------------------------------------------------------------------------

-- Enable file type detection.
-- Also load indent files, to automatically do language-dependent indenting.
cmd 'filetype plugin indent on'
opt.expandtab = true -- Use spaces, not tabs
opt.tabstop = 2 -- A tab is two spaces
opt.shiftwidth = 2 -- An autoindent (with <<) is two spaces
opt.softtabstop = 2 -- Should be the same value of shiftwidth
opt.shiftround = true -- Always round the indent to a multiple of 'shiftwidth'

--------------------------------------------------------------------------------
-- WILDMENU
--------------------------------------------------------------------------------

-- Use emacs-style tab completion when selecting files, etc
opt.wildmode = { 'longest', 'list' }

opt.wildignore:append { '.hg', '.git', '.svn' } -- Version control
opt.wildignore:append { '*.orig' } -- Merge resolution files

opt.wildignore:append { '*.aux', '*.out', '*.toc' } -- LaTeX intermediate files
opt.wildignore:append { '*.bmp', '*.gif', '*.jpg', '*.jpeg', '*.png' } -- Binary images
opt.wildignore:append { '*.sw?' } -- Vim swap files
opt.wildignore:append { '*.DS_Store' } -- OSX bullshit
opt.wildignore:append { '*/cassettes/**/*.yml' } -- Ruby VCR
opt.wildignore:append { '*/tmp/**' }
opt.wildignore:append { '*/vendor/bundle' } -- Cached ruby gems

--------------------------------------------------------------------------------
-- LIST
--------------------------------------------------------------------------------

-- A tab should display as spaces
-- A trailing whitespace as "."
-- The character to show when wrap is off and the line continues beyond the screen as "…"
opt.list = true -- Show invisible characters
opt.listchars = { extends = '…', precedes = '…', tab = '  ', trail = '·' }

--------------------------------------------------------------------------------
-- CONVENIENCE MAPPINGS
--------------------------------------------------------------------------------

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then options = vim.tbl_extend('force', options, opts) end

  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Remapping leader to ,
vim.g.mapleader = ','

-- Aliasing the new leader ',' to the default one '\'
map('n', '<Bslash>', ',', { noremap = false })

-- Better ESC
map('i', 'jk', '<Esc>')

-- Use sane regexes
map('n', '/', '/\\v')
map('v', '/', '/\\v')

-- Select the contents of the current line, excluding indentation.
map('n', 'vv', '^vg_')

-- Don't lose selection when shifting sidewards
map('x', '<', '<gv')
map('x', '>', '>gv')

-- Keep search matches in the middle of the window.
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')
-- Same when jumping around
map('n', 'g;', 'g;zz')
map('n', 'g,', 'g,zz')

-- It's 2021.
map('', 'j', 'gj')
map('', 'k', 'gk')
map('', 'gj', 'j')
map('', 'gk', 'k')

-- Better navigation between windows
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- Clear the search buffer when hitting return
function _G.map_enter()
  map('n', '<cr>', ':nohlsearch<cr>:call clearmatches()<cr>')
end
_G.map_enter()

-- Make escape get out of pumenu mode and go back to the uncompleted word
map('i', '<Esc>', 'pumvisible() ? "<C-e>" : "<Esc>"', { expr = true })

-- Typos
cmd 'command! -bang E e<bang>'
cmd 'command! -bang Q q<bang>'
cmd 'command! -bang W w<bang>'
cmd 'command! -bang QA qa<bang>'
cmd 'command! -bang Qa qa<bang>'
cmd 'command! -bang Wa wa<bang>'
cmd 'command! -bang WA wa<bang>'
cmd 'command! -bang Wq wq<bang>'
cmd 'command! -bang WQ wq<bang>'

--------------------------------------------------------------------------------
-- EXTRA
--------------------------------------------------------------------------------

-- Sudo to write
map('c', 'w!!', 'w !sudo tee % >/dev/null')

-- Open files in directory of current file
map('c', '%%', "<C-R>=expand('%:h').'/'<cr>")
map('', '<leader>e', ':edit %%', { noremap = false })

-- Find merge conflict markers
map('n', '<leader>cf', '<ESC>/\\v^[<=>]{7}( .*|$)<CR>', { silent = true })

-- Shorcut for setting a pry breakpoint
cmd "iabbrev xpry require 'pry'; binding.pry<Esc>F%s<c-o>:call getchar()<CR>"

-- Convert ruby 1.8 hash into ruby 1.9
map('n', '<leader>h', ':%s/:\\([^ ]*\\)\\(\\s*\\)=>/\\1:/g<CR>')

-- Clean trailing whitespaces
map('n', '<leader>w', "mz:%s/\\s\\+$//<CR>:let @/=''<CR>`z")

-- Edit .vimrc file
map('n', '<leader>EV', ':vsplit $MYVIMRC<cr>')

-- Reload .vimrc file
map('n', '<leader>RV', ':source $MYVIMRC<cr>')

-- Edit elvish config file
map('n', '<leader>EE', ':vsplit ~/.elvish/rc.elv<cr>')

-- Edit fish config file
map('n', '<leader>EF', ':vsplit ~/.config/fish/config.fish<cr>')

-- Edit github pull request
map('n', '<leader>EG', ":execute 'split' fnameescape(FugitiveFind('.git/descriptions/'.fugitive#head().'.mk'))<CR>")

-- Edit tmux config file
map('n', '<leader>ET', ':vsplit ~/.tmux.conf<cr>')

-- Replace grep with ripgrep
if vim.fn.executable('rg') == 1 then opt.grepprg = "rg --vimgrep" end

-- Auto open the search result
cmd 'autocmd QuickFixCmdPost *grep* cwindow'

-- Spell checking and automatic wrapping at the 72 chars to git commit message
cmd 'autocmd Filetype gitcommit setlocal spell textwidth=72'

-- .slim is a slm filetype
cmd 'autocmd BufNewFile,BufRead *.slim set syntax=slm'

--------------------------------------------------------------------------------
-- ARROW KEYS ARE UNACCEPTABLE
--------------------------------------------------------------------------------

map('', '<Left>', ':echo "Arrow keys are unnaceptable"<CR>', { noremap = false })
map('', '<Right>', ':echo "Arrow keys are unnaceptable"<CR>', { noremap = false })
map('', '<Up>', ':echo "Arrow keys are unnaceptable"<CR>', { noremap = false })
map('', '<Down>', ':echo "Arrow keys are unnaceptable"<CR>', { noremap = false })

--------------------------------------------------------------------------------
-- RENAME CURRENT FILE
--------------------------------------------------------------------------------

function _G.rename_file(mode, lhs, rhs, opts)
  local old_name = fn.expand('%')
  local new_name = fn.input('New file name: ', vim.fn.expand('%'), 'file')

  if (new_name ~= '' and new_name ~= old_name) then
    cmd(':saveas '.. new_name)
    cmd(':silent !rm '.. old_name)
    cmd('redraw!')
  end
end

map('', '<leader>n', ':call v:lua.rename_file()<cr>')

--------------------------------------------------------------------------------
-- PROMOTE VARIABLE TO RSPEC LET
--------------------------------------------------------------------------------

function _G.promote_to_let()
    cmd(':normal! dd')
    cmd(':normal! P')
    cmd(':.s/\\(\\w\\+\\) = \\(.*\\)$/let(:\\1) { \\2 }/')
    cmd(':normal ==')
end

map('', '<leader>p', ':call v:lua.promote_to_let()<cr>')

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
    autocmd BufEnter * highlight OverLength ctermbg=darkgrey guibg=#111111
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

cmd([[
  augroup config-github-complete
    " Remove ALL autocommands for the current group.
    autocmd!

    " Github completion on git commit messages
    autocmd FileType gitcommit setl omnifunc=rhubarb#omnifunc | call SuperTabChain(&omnifunc, "<c-p>")
  augroup END
]])

--------------------------------------------------------------------------------
-- PLUGINS
--------------------------------------------------------------------------------

----------------------------
-- Easy Align
----------------------------
-- Start interactive EasyAlign in visual mode (e.g. vipga)
map('x', 'ga', '<Plug>(EasyAlign)', { noremap = false })
-- Start interactive EasyAlign for a motion/text object (e.g. gaip)
map('n', 'ga', '<Plug>(EasyAlign)', { noremap = false })

----------------------------
-- FZF
----------------------------
-- Act like CtrlP
vim.g.fzf_action = { ['ctrl-s'] = 'split', ['ctrl-v'] = 'vsplit' }
-- Enable per-command history
vim.g.fzf_history_dir = '~/.local/share/fzf-history'
-- Show preview window with colors using bat
vim.env.FZF_DEFAULT_OPTS = "--ansi --preview-window 'right:60%' --margin=1 --preview 'bat --color=always --line-range :150 {}'"

-- <C-p> or <C-t> to search files
map('n', '<C-t>', ':FZF -m<cr>', { silent = true })
map('n', '<C-p>', ':FZF -m<cr>', { silent = true })

----------------------------
-- Gitsigns
----------------------------
require('gitsigns').setup {
  on_attach = function(bufnr)
    -- Navigation
    map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
    map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

    -- Actions
    map('n', '<leader>hs', ':Gitsigns stage_hunk<CR>')
    map('v', '<leader>hs', ':Gitsigns stage_hunk<CR>')
    map('n', '<leader>hr', ':Gitsigns reset_hunk<CR>')
    map('v', '<leader>hr', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>')
    map('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>')
    map('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>')
    map('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>')
    map('n', '<leader>hb', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
    map('n', '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<CR>')
    map('n', '<leader>hd', '<cmd>Gitsigns diffthis<CR>')
    map('n', '<leader>hD', '<cmd>lua require"gitsigns".diffthis("~")<CR>')
    map('n', '<leader>td', '<cmd>Gitsigns toggle_deleted<CR>')

    -- Text object
    map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}

----------------------------
-- NerdCommenter
----------------------------
map('', '<leader>/', '<plug>NERDCommenterToggle<CR>', { noremap = false })
map('i', '<leader>/', '<Esc><plug>NERDCommenterToggle<CR>i', { noremap = false })

----------------------------
-- nvim-cmp
----------------------------
local cmp = require('cmp')

cmp.setup {
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    })
  },
  sources = {
    { name = 'buffer' },
    { name = 'emoji' },
    { name = 'nvim_lsp' },
    { name = 'tags' },
  }
}

----------------------------
-- Package Info
----------------------------
require('package-info').setup()

----------------------------
-- Projectionist
----------------------------
-- Global configuration file
vim.g.projectionist_heuristics = vim.fn.json_decode(vim.fn.join(vim.fn.readfile(vim.fn.expand('~/.config/projections.json'))))
-- Jump to alternate file
map('n', '<leader>.', ':A<cr>')

----------------------------
-- Supertab
----------------------------
-- Navigate the completion menu from top to bottom
vim.g.SuperTabDefaultCompletionType = '<c-n>'

----------------------------
-- Treesitter
----------------------------
require('nvim-treesitter.configs').setup {
  ensure_installed = "all",
  highlight = {
    enable = true -- enable extension
  }
}

----------------------------
-- Treesitter textobjects
----------------------------

require('nvim-treesitter.configs').setup {
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
      }
    },

    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist

      goto_next_start = {
        ["]m"] = "@function.outer"
      },
      goto_next_end = {
        ["]M"] = "@function.outer"
      },
      goto_previous_start = {
        ["[m"] = "@function.outer"
      },
      goto_previous_end = {
        ["[M"] = "@function.outer"
      }
    }
  }
}

----------------------------
-- Treesitter textsubjects
----------------------------

require('nvim-treesitter.configs').setup {
    textsubjects = {
        enable = true,
        keymaps = {
            ['.'] = 'textsubjects-smart',
            [';'] = 'textsubjects-container-outer'
        }
    }
}

----------------------------
-- Trouble
----------------------------
require('trouble').setup {
  icons = false -- do not use devicons for filenames
}

-- Diagnostic icons
local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

map('n', '<leader>xw', '<cmd>Trouble lsp_workspace_diagnostics<cr>', { silent = true })
map('n', '<leader>xd', '<cmd>Trouble lsp_document_diagnostics<cr>', { silent = true })
map('n', '<leader>xx', '<cmd>Trouble<cr>', { silent = true })
map('n', 'gR', '<cmd>Trouble lsp_references<cr>', { silent = true })

--------------------------------------------------------------------------------
-- Load other config files
--------------------------------------------------------------------------------

require 'my_modules/lsp'
