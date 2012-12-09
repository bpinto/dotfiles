set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Bundle 'aliva/vim-fish'
Bundle 'altercation/vim-colors-solarized'
Bundle 'godlygeek/tabular'
Bundle 'groenewege/vim-less'
Bundle 'kien/ctrlp.vim'
Bundle 'Lokaltog/vim-powerline'
Bundle 'mirell/vim-matchit'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/syntastic'
Bundle 'skalnik/vim-vroom'
Bundle 'tpope/vim-bundler'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-fugitive'
Bundle 'vim-scripts/AutoTag'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" EDITOR CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use vim, no vi defaults
set nocompatible
" Prevent a security hole
set modelines=0
" Set default encoding to UTF-8
set encoding=utf-8
" This makes RVM work inside Vim. I have no idea why.
set shell=bash
" Prevent Vim from clobbering the scrollback buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC EDITING CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Allow backspacing over everything in insert mode
set backspace=indent,eol,start
" Allow unsaved background buffers and remember marks/undo for them
set hidden
" Remember more commands and search history
set history=10000
" Use already open buffer
set switchbuf=useopen
" Write the contents of the file if it has been modified
set autowrite

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INTERFACE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable highlighting for syntax
syntax enable
" Set window title
set title
" Display incomplete commands
set showcmd
" Highlight current line
set cursorline
" Show line numbers
set number
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
" Show line numbers
set number
" Line number left margin
set numberwidth=5
" Always show the status bar
set laststatus=2
" Fix vim auto-complete slowness in large projects
set foldmethod=manual

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COLOR
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 256 colors
set t_Co=256
" Background color
set background=dark
" Theme
colorscheme solarized

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SEARCH CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Incremental searching
set incsearch
" Highlight matches
set hlsearch
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
set backupdir=~/.vim/tmp/backup//
" Swap files
set directory=~/.vim/tmp/swap//
" It's 2012, Vim.
set noswapfile
" Make vim able to edit crontab files again.
set backupskip=/tmp/*,/private/tmp/*"
" Enable undo history
set undofile
" Undo files
set undodir=~/.vim/tmp/undo//

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INDENTATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" required!
filetype off
" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on
" Automatic alignment during insertions
set autoindent
" Use spaces, not tabs
set expandtab
" A tab is two spaces
set tabstop=2
" An autoindent (with <<) is two spaces
set shiftwidth=2
" Should be the same value of shiftwidth
set softtabstop=2

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" WILDMENU
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Make tab completion for files/buffers act like bash
set wildmenu
" Use emacs-style tab completion when selecting files, etc
set wildmode=longest,list

set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.orig                           " Merge resolution files

set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit
set wildignore+=*/cassettes/**/*.yml

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LIST
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Show invisible characters
set list
" Reset the listchars
set listchars=""
" A tab should display as "  ", trailing whitespace as "."
set listchars=tab:\ \
" Show trailing spaces as dots
set listchars+=trail:.
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

" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Clear the search buffer when hitting return
function! MapCR()
  nnoremap <cr> :nohlsearch<cr>
endfunction
call MapCR()

" Go to alternate file
nnoremap <leader><leader> <c-^>

" Clean trailing whitespaces
nnoremap <leader>w mz:%s/\s\+$//<cr>:let @/=''<cr>`z

" System clipboard interaction
nnoremap <leader>Y :.!pbcopy<CR>uk<CR>
vnoremap <leader>Y :!pbcopy<CR>uk<CR>
noremap <leader>P :set paste<CR>:r !pbpaste<CR>:set nopaste<CR>

" Select (charwise) the contents of the current line, excluding indentation.
nnoremap vv ^vg_

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

" Find merge conflict markers
nmap <silent> <leader>cf <ESC>/\v^[<=>]{7}( .*\|$)<CR>

" Shorcut for setting a pry breakpoint
iab xpry require 'pry'; binding.pry

" Convert ruby 1.8 hash into ruby 1.9
nnoremap <leader>h :%s/:\([^ ]*\)\(\s*\)=>/\1:/g<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" EXTRA
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap  <F1> :set invfullscreen<CR>
inoremap <F1> <ESC>:set invfullscreen<CR>a

" Sudo to write
cnoremap w!! w !sudo tee % >/dev/null

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
" Edit .zshrc file
nnoremap <leader>EZ :vsplit ~/.zshrc<cr>
" Edit fish config file
nnoremap <leader>EF :vsplit ~/.config/fish/config.fish<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ARROW KEYS ARE UNACCEPTABLE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <Left> :echo "Arrow keys are unacceptable"<CR>
map <Right> :echo "Arrow keys are unacceptable"<CR>
map <Up> :echo "Arrow keys are unacceptable"<CR>
map <Down> :echo "Arrow keys are unacceptable"<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OPEN FILES IN DIRECTORY OF CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%

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
  let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') != -1
  if going_to_spec
    if in_app
      let new_file = substitute(new_file, '^app/', '', '')
    end
    let new_file = substitute(new_file, '\.rb$', '_spec.rb', '')
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
" OpenChangedFiles COMMAND
" Open a split for each dirty file in git
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! OpenChangedFiles()
  only " Close all windows, unless they're modified
  let status = system('git status -s | grep "^ \?\(M\|A\|UU\)" | sed "s/^.\{3\}//"')
  let filenames = split(status, "\n")
  exec "edit " . filenames[0]
  for filename in filenames[1:]
    exec "sp " . filename
  endfor
endfunction
command! OpenChangedFiles :call OpenChangedFiles()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM AUTOCMDS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  autocmd FileType text setlocal textwidth=78
  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " For ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set ai sw=2 sts=2 et
  " For python autoindent with four spaces
  autocmd FileType python set sw=4 sts=4 et
  " For fish, autoindent with two spaces
  autocmd FileType fish set ai sw=2 sts=2 et

  autocmd! BufRead,BufNewFile *.sass setfiletype sass

  autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:&gt;

  " Indent p tags
  autocmd FileType html,eruby if g:html_indent_tags !~ '\\|p\>' | let g:html_indent_tags .= '\|p\|li\|dt\|dd' | endif

  " Don't syntax highlight markdown because it's often wrong
  autocmd! FileType mkd setlocal syn=off

  " Leave the return key alone when in command line windows, since it's used
  " to run commands there.
  autocmd! CmdwinEnter * :unmap <cr>
  autocmd! CmdwinLeave * :call MapCR()

  " Highlight characters longer than 80 characters
  autocmd BufEnter * highlight OverLength ctermbg=black guibg=#003542 "guibg=#592929
  autocmd BufEnter * match OverLength /\%81v.*/
augroup END

" Trailing whitespace change on insert mode
augroup trailing
  au!
  au InsertEnter * :set listchars-=trail:.
  au InsertEnter * :set listchars+=trail:⌴
  au InsertLeave * :set listchars+=trail:.
  au InsertLeave * :set listchars-=trail:⌴
augroup END

" Save when losing focus
au FocusLost * :silent! wall

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CtrlP Menu remapping
noremap <C-t> :CtrlP<CR>
inoremap <C-t> <ESC>:CtrlP<CR>

" NerdCommenter Menu remapping
map  <leader>/ <plug>NERDCommenterToggle<CR>
imap <leader>/ <Esc><plug>NERDCommenterToggle<CR>i

" Use custom icons and arrows for symbols and dividers
let g:Powerline_symbols = 'fancy'

" Jump cursor to the first detected error when saving
let g:syntastic_auto_jump = 1
" Symbol when have errors
let g:syntastic_error_symbol = '✗'
" Symbol when have warnings
let g:syntastic_warning_symbol = '⚠'
