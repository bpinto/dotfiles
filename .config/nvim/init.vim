" Use bash as default shell
set shell=bash

call plug#begin('~/.config/nvim/plugged')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'airblade/vim-gitgutter'
Plug 'ajh17/Spacegray.vim'
Plug 'aliva/vim-fish'
Plug 'bling/vim-airline'
Plug 'chriskempson/base16-vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'elixir-lang/vim-elixir'
Plug 'ervandew/supertab'
Plug 'groenewege/vim-less'
Plug 'junegunn/vim-easy-align'
Plug 'kana/vim-textobj-user'
Plug 'kassio/neoterm'
Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }
Plug 'mhartington/oceanic-next'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'onemanstartup/vim-slim'
Plug 'othree/html5.vim'
Plug 'rhysd/github-complete.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'vim-ruby/vim-ruby'

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" EDITOR CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Prevent a security hole
set modelines=0
" Prevent Vim from clobbering the scrollback buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC EDITING CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Allow unsaved background buffers and remember marks/undo for them.
set hidden
" Use already open buffer
set switchbuf=useopen
" Write the contents of the file if it has been modified
set autowrite
" Use only one space after period when joining lines
set nojoinspaces

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INTERFACE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable highlighting for syntax
syntax enable
" Syntax coloring lines that are too long just slows down the world
set synmaxcol=128
" To avoid scrolling problems
set lazyredraw
" Set window title
set title
" Display incomplete commands
set showcmd
" Highlight current line
set cursorline
" Show line numbers
set number
" Line number left margin
set numberwidth=5
" Minimal window width
set winwidth=79
" Keep more context when scrolling off the end of a buffer (3 lines)
set scrolloff=3
" Height of the command bar
set cmdheight=2
" When on, splitting a window will put the new window below the current one
set splitbelow
" When on, splitting a window will put the new window right of the current one
set splitright
" Dashed border
set fillchars=vert:\|
" Fix vim auto-complete slowness in large projects
set foldmethod=manual

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COLOR
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Background color
set background=dark
" Theme
colorscheme spacegray
" Enable true colors in the terminal
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
" Enable cursor shape in the terminal
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

" More information, e.g. :verbose highlight VertSplit
" Vertical split border
highlight VertSplit cterm=NONE ctermfg=8 ctermbg=NONE guifg=NONE guibg=NONE
" Line numbers
highlight LineNr ctermfg=246 ctermbg=None cterm=NONE guifg=#909194 guibg=None gui=NONE
" Git Gutter column equal to Line number
highlight clear SignColumn
" Git Gutter column with signs
highlight GitGutterAdd ctermfg=2 ctermbg=NONE guibg=NONE
highlight GitGutterChange ctermfg=4 ctermbg=NONE guibg=NONE
highlight GitGutterDelete ctermfg=1 ctermbg=NONE guibg=NONE
highlight GitGutterChangeDelete ctermfg=5 ctermbg=NONE guibg=NONE

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SEARCH CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Show matching bracket when text indicator is over them
set showmatch
" Make searches case-sensitive only if they contain upper-case characters
set ignorecase smartcase

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BACKUP
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable backups
set backup
" Backups
set backupdir=~/.local/share/nvim/backup//
" Swap files
set directory=~/.local/share/nvim/swap//
" It's 2012, Vim.
set noswapfile
" Make vim able to edit crontab files again.
set backupskip=/tmp/*,/private/tmp/*"
" Enable undo history
set undofile
" Undo files
set undodir=~/.local/share/nvim/undo//

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INDENTATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on
" Use spaces, not tabs
set expandtab
" A tab is two spaces
set tabstop=2
" An autoindent (with <<) is two spaces
set shiftwidth=2
" Should be the same value of shiftwidth
set softtabstop=2
" Always round the indent to a multiple of 'shiftwidth'
set shiftround

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" WILDMENU
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use emacs-style tab completion when selecting files, etc
set wildmode=longest,list

set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.orig                           " Merge resolution files

set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit
set wildignore+=*/cassettes/**/*.yml             " Ruby vcr
set wildignore+=*/build                          " Ruby motion
set wildignore+=*/tmp/**
set wildignore+=*/vendor/bundle                  " Cached gems

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LIST
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Show invisible characters
set list
" Reset the listchars
set listchars=""
" A tab should display as "  ", trailing whitespace as "."
set listchars=tab:\ \
" Show trailing spaces as middle dots
set listchars+=trail:·
" The character to show in the last column when wrap is off and the line continues beyond the right of the screen
set listchars+=extends:>
" The character to show in the last column when wrap is off and the line continues beyond the right of the screen
set listchars+=precedes:<

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CONVENIENCE MAPPINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remapping leader to ,
let mapleader=","
" Aliasing the new leader ',' to the default one '\'
nmap \ ,

" Better ESC
inoremap jk <Esc>

" Use sane regexes.
nnoremap / /\v
vnoremap / /\v

" * Disabled while using Vim Tmux Navigator plugin *
" Move around splits with <c-hjkl>
"nnoremap <c-j> <c-w>j
"nnoremap <c-k> <c-w>k
"nnoremap <c-h> <c-w>h
"nnoremap <c-l> <c-w>l

" Clear the search buffer when hitting return
function! MapCR()
  nnoremap <cr> :nohlsearch<cr>
endfunction
call MapCR()

" Clean trailing whitespaces
nnoremap <leader>w mz:%s/\s\+$//<cr>:let @/=''<cr>`z

" System clipboard interaction
noremap <leader>P :set paste<CR>:r !pbpaste<CR>:set nopaste<CR>

" Select (charwise) the contents of the current line, excluding indentation.
nnoremap vv ^vg_

" Don't lose selection when shifting sidewards
xnoremap < <gv
xnoremap > >gv

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv
" Same when jumping around
nnoremap g; g;zz
nnoremap g, g,zz

" It's 2012.
noremap j gj
noremap k gk
noremap gj j
noremap gk k

" Make Y consistent with C and D.
nnoremap Y y$

" Find merge conflict markers
nmap <silent> <leader>cf <ESC>/\v^[<=>]{7}( .*\|$)<CR>

" Shorcut for setting a pry breakpoint
iab xpry require 'pry'; binding.pry

" Convert ruby 1.8 hash into ruby 1.9
nnoremap <leader>h :%s/:\([^ ]*\)\(\s*\)=>/\1:/g<CR>

" Make escape get out of pumenu mode and go back to the uncompleted word
inoremap <expr> <Esc> pumvisible() ? "\<C-e>" : "\<Esc>"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" EXTRA
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sudo to write
cnoremap w!! w !sudo tee % >/dev/null

" Open files in directory of current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%

" Typos
command! -bang E e<bang>
command! -bang Q q<bang>
command! -bang W w<bang>
command! -bang QA qa<bang>
command! -bang Qa qa<bang>
command! -bang Wa wa<bang>
command! -bang WA wa<bang>
command! -bang Wq wq<bang>
command! -bang WQ wq<bang>

" Edit .vimrc file
nnoremap <leader>EV :vsplit $MYVIMRC<cr>
" Reload .vimrc file
nnoremap <leader>RV :source $MYVIMRC<cr>
" Edit fish config file
nnoremap <leader>EF :vsplit ~/.config/fish/config.fish<cr>
" Edit tmux config file
nnoremap <leader>ET :vsplit ~/.tmux.conf<cr>

" Replace grep with silver search
cnoreabbrev ag grep
if executable("ag")
  set grepprg=ag\ --nogroup\ --nocolor\ --column
endif

" Auto open the search result
autocmd QuickFixCmdPost *grep* cwindow

" Spell checking and automatic wrapping at the 72 chars to git commit message
autocmd Filetype gitcommit setlocal spell textwidth=72

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ARROW KEYS ARE UNACCEPTABLE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <Left> :echo "Arrow keys are unacceptable"<CR>
map <Right> :echo "Arrow keys are unacceptable"<CR>
map <Up> :echo "Arrow keys are unacceptable"<CR>
map <Down> :echo "Arrow keys are unacceptable"<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>n :call RenameFile()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PROMOTE VARIABLE TO RSPEC LET
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! PromoteToLet()
  :normal! dd
  " :exec '?^\s*it\>'
  :normal! P
  :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
  :normal ==
endfunction
:command! PromoteToLet :call PromoteToLet()
:map <leader>p :PromoteToLet<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SWITCH BETWEEN TEST AND PRODUCTION CODE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction
function! AlternateForCurrentFile()
  let current_file = expand("%")
  let new_file = current_file
  let in_spec = match(current_file, '^spec/') != -1
  let going_to_spec = !in_spec
  let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') != -1 || match(current_file, '\<helpers\>') != -1 || match(current_file, '\<resources\>') != -1

  if going_to_spec
    if in_app
      let new_file = substitute(new_file, '^app/', '', '')
    end
    let new_file = substitute(new_file, '\.rb$', '_spec.rb', '')
    let new_file = substitute(new_file, '\.jbuilder$', '.jbuilder_spec.rb', '')
    let new_file = 'spec/' . new_file
  else
    let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
    let new_file = substitute(new_file, '^spec/', '', '')
    if in_app
      let new_file = 'app/' . new_file
    end
  endif
  return new_file
endfunction
nnoremap <leader>. :call OpenTestAlternate()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM AUTOCMDS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup cursor-position
  " Remove ALL autocommands for the current group.
  autocmd!

  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
augroup END

augroup highlight
  " Remove ALL autocommands for the current group.
  autocmd!

  " Leave the return key alone when in quickfix windows, since it's used
  " to run commands there.
  autocmd BufEnter * :if &buftype is# "quickfix" | :unmap <cr>| else | :call MapCR()| endif

  " Leave the return key alone when in command line windows, since it's used
  " to run commands there.
  autocmd CmdwinEnter * :unmap <cr>
  autocmd CmdwinLeave * :call MapCR()

  " Highlight characters longer than 100 characters
  autocmd BufEnter * highlight OverLength ctermfg=8 ctermbg=10 guifg=#585858 guibg=#282828
  autocmd BufEnter * match OverLength /\%101v.*/
augroup END

augroup autosave
  " Remove ALL autocommands for the current group.
  autocmd!

  " Autosave files/buffers when losing focus
  autocmd FocusLost * :silent! wall
augroup END

augroup config-github-complete
  " Remove ALL autocommands for the current group.
  autocmd!

  " Github completion on git commit messages
  autocmd FileType gitcommit setl omnifunc=github_complete#complete
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Matchit
" Enable matchit.vim
runtime macros/matchit.vim

" FZF
set rtp+=/usr/local/opt/fzf
" Act like CtrlP
let g:fzf_action = {
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }
" <C-p> or <C-t> to search files
nnoremap <silent> <C-t> :FZF -m<cr>
nnoremap <silent> <C-p> :FZF -m<cr>

" NerdCommenter
" Menu remapping
map  <leader>/ <plug>NERDCommenterToggle<CR>
imap <leader>/ <Esc><plug>NERDCommenterToggle<CR>i

" Airline
let g:airline_theme = 'zenburn'
" Enable usage of patched powerline font symbols
let g:airline_powerline_fonts = 1

"Syntastic
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
" Jump cursor to the first detected error when saving
let g:syntastic_auto_jump = 1
" Enable rubocop check
"let g:syntastic_ruby_checkers = ['mri', 'rubocop']
" Most issues returned by rubocop are warnings
let g:syntastic_quiet_messages = {'level': 'warnings'}

" Neoterm
nnoremap <silent> <leader>a :call neoterm#test#run('all')<cr>
nnoremap <silent> <leader>t :call neoterm#test#run('file')<cr>
nnoremap <silent> <leader>s :call neoterm#test#run('current')<cr>
nnoremap <silent> <leader>l :call neoterm#test#rerun()<cr>

" Easy Plugin
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Supertab
" Navigate the completion menu from top to bottom
let g:SuperTabDefaultCompletionType = "<c-n>"
