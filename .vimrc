set nocompatible                                 " Use vim, no vi defaults
filetype off
filetype plugin indent on

" Vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

" General {{{
Bundle 'kien/ctrlp.vim'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
Bundle 'tsaleh/vim-align'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-rails'
Bundle 'benmills/vimux'
" }}}

" Colors {{{
Bundle 'sjl/badwolf'
Bundle 'altercation/vim-colors-solarized'
Bundle 'tomasr/molokai'
" }}}

" Basic options ----------------------------------------------------------- {{{

set encoding=utf-8                               " Set default encoding to UTF-8
set modelines=0
set autoindent
set showmode
set showcmd
set hidden
set visualbell
set ttyfast
set ruler                                        " Show line and column number
set backspace=indent,eol,start                   " backspace through everything in insert mode
set number                                       " Show line numbers
set norelativenumber
set laststatus=2                                 " always show the status bar
set history=1000
set undofile
set undoreload=10000
set shell=/bin/zsh
set lazyredraw
set matchtime=3
set showbreak=↪
set splitbelow
set splitright
set fillchars=diff:⣿,vert:│
set autowrite
set shiftround
set autoread
set title
set linebreak
set dictionary=/usr/share/dict/words
set spellfile=~/.vim/custom-dictionary.utf-8.add
set colorcolumn=+1
set list                                         " Show invisible characters

" List chars
set listchars=""                                 " Reset the listchars
set listchars=tab:\ \                            " a tab should display as "  ", trailing whitespace as "."
set listchars+=trail:.                           " show trailing spaces as dots
set listchars+=extends:>                         " The character to show in the last column when wrap is
                                                 " off and the line continues beyond the right of the screen
set listchars+=precedes:<                        " The character to show in the last column when wrap is
                                                 " off and the line continues beyond the right of the screen

" Time out on key codes but not mappings.
" Basically this makes terminal Vim work sanely.
set notimeout
set ttimeout
set ttimeoutlen=10

" Make Vim able to edit crontab files again.
set backupskip=/tmp/*,/private/tmp/*"

" Better Completion
set completeopt=longest,menuone,preview

" Better ESC
inoremap jk <Esc>

" Save when losing focus
au FocusLost * :silent! wall

" Resize splits when the window is resized
au VimResized * :wincmd =

" Cursorline {{{
" Only show cursorline in the current window and in normal mode.

augroup cline
    au!
    au WinLeave * set nocursorline
    au WinEnter * set cursorline
    au InsertEnter * set nocursorline
    au InsertLeave * set cursorline
augroup END

" }}}
" cpoptions+=J, dammit {{{

" Something occasionally removes this.  If I manage to find it I'm going to
" comment out the line and replace all its characters with 'FUCK'.
augroup twospace
    au!
    au BufRead * :set cpoptions+=J
augroup END

" }}}
" Trailing whitespace {{{
" Only shown when not in insert mode so I don't go insane.

augroup trailing
    au!
    au InsertEnter * :set listchars-=trail:⌴
    au InsertLeave * :set listchars+=trail:⌴
augroup END

" }}}
" Wildmenu completion {{{

set wildmenu
set wildmode=list:longest

set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit

set wildignore+=*.luac                           " Lua byte code

set wildignore+=migrations                       " Django migrations
set wildignore+=*.pyc                            " Python byte code

set wildignore+=*.orig                           " Merge resolution files

" }}}
" Line Return {{{

" Make sure Vim returns to the same line when you reopen a file.
" Thanks, Amit
augroup line_return
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END

" }}}
" Tabs, spaces, wrapping {{{

set tabstop=2                                    " a tab is two spaces
set shiftwidth=2                                 " an autoindent (with <<) is two spaces
set softtabstop=2
set expandtab                                    " use spaces, not tabs
set wrap                                         " wrap lines
set textwidth=80
set formatoptions=qrn1
set colorcolumn=+1

" }}}
" Backups {{{

set undodir=~/.vim/tmp/undo//                    " undo files
set backupdir=~/.vim/tmp/backup//                " backups
set directory=~/.vim/tmp/swap//                  " swap files
set backup                                       " enable backups
set noswapfile                                   " It's 2012, Vim.

" }}}
" Leader {{{

let mapleader = ","
let maplocalleader = "\\"

" }}}
" Color scheme {{{

syntax enable                                    " Turn on syntax highlighting allowing local overrides
set background=dark
let g:badwolf_html_link_underline = 0
colorscheme badwolf

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" }}}

" }}}
" Convenience mappings ---------------------------------------------------- {{{

" Fuck you, help key.
noremap  <F1> :set invfullscreen<CR>
inoremap <F1> <ESC>:set invfullscreen<CR>a

" Stop it, hash key.
inoremap # X<BS>#

" Kill window
nnoremap K :q<cr>

" Unfuck my screen
nnoremap <leader>u :syntax sync fromstart<cr>:redraw!<cr>

" System clipboard interaction
" From https://github.com/henrik/dotfiles/blob/master/vim/config/mappings.vim
noremap <leader>y "*y
noremap <leader>p :set paste<CR>"*p<CR>:set nopaste<CR>
noremap <leader>P :set paste<CR>"*P<CR>:set nopaste<CR>

" I constantly hit "u" in visual mode when I mean to "y". Use "gu" for those rare occasions.
" From https://github.com/henrik/dotfiles/blob/master/vim/config/mappings.vim
vnoremap u <nop>
vnoremap gu u

" For some reason ctags refuses to ignore Python variables, so I'll just hack
" the tags file with sed and strip them out myself.
"
" Sigh.
nnoremap <leader><cr> :silent !/usr/local/bin/ctags -R . && sed -i .bak -E -e '/^[^	]+	[^	]+.py	.+v$/d' tags<cr>:redraw!<cr>

" Highlight Group(s)
nnoremap <F8> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
                        \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
                        \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Clean trailing whitespace
nnoremap <leader>w mz:%s/\s\+$//<cr>:let @/=''<cr>`z

" Send visual selection to gist.github.com as a private, filetyped Gist
" Requires the gist command line too (brew install gist)
vnoremap <leader>G :w !gist -p -t %:e \| pbcopy<cr>
vnoremap <leader>UG :w !gist -p \| pbcopy<cr>

" Send visual selection to paste.bpinto.com
vnoremap <c-p> :w !curl -sF 'sprunge=<-' 'http://paste.bpinto.com' \| tr -d '\n ' \| pbcopy && open `pbpaste`<cr>

" Change case
inoremap <C-u> <esc>gUiwea

" Emacs bindings in command line mode
cnoremap <c-a> <home>
cnoremap <c-e> <end>

" Diffoff
nnoremap <leader>D :diffoff!<cr>

" Formatting, TextMate-style
nnoremap Q gqip
vnoremap Q gq

" Easier linewise reselection
nnoremap <leader>V V`]

" Keep the cursor in place while joining limes
nnoremap J mzJ`z

" Split line (sister to [J]oin lines)
" The normal use of S is covered by cc, so don't worry about shadowing it.
nnoremap S i<cr><esc><right>mwgk:silent! s/\v +$//<cr>:noh<cr>`w

" HTML tag closing
inoremap <C-_> <Space><BS><Esc>:call InsertCloseTag()<cr>a

" Less chording
nnoremap ; :

" Cmdheight switching
nnoremap <leader>1 :set cmdheight=1<cr>
nnoremap <leader>2 :set cmdheight=2<cr>

" Source
vnoremap <leader>S y:execute @@<cr>:echo 'Sourced selection.'<cr>
nnoremap <leader>S ^vg_y:execute @@<cr>:echo 'Sourced line.'<cr>

" Marks and Quotes
noremap ' `
noremap æ '
noremap ` <C-^>

" Select (charwise) the contents of the current line, excluding indentation.
" Great for pasting Python lines into REPLs.
nnoremap vv ^vg_

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

" I suck at typing.
nnoremap <localleader>= ==
vnoremap - =

" Toggle paste
set pastetoggle=<F6>

" Toggle [i]nvisible characters
nnoremap <leader>i :set list!<cr>

" Drag Lines {{{

" <m-j> and <m-k> to drag lines in any mode
noremap ∆ :m+<CR>
noremap ˚ :m-2<CR>
inoremap ∆ <Esc>:m+<CR>
inoremap ˚ <Esc>:m-2<CR>
vnoremap ∆ :m'>+<CR>gv
vnoremap ˚ :m-2<CR>gv

" }}}
" Easy filetype switching {{{

nnoremap _md :set ft=markdown<CR>
nnoremap _hd :set ft=htmldjango<CR>
nnoremap _jt :set ft=htmljinja<CR>
nnoremap _js :set ft=javascript<CR>
nnoremap _cw :set ft=confluencewiki<CR>
nnoremap _pd :set ft=python.django<CR>
nnoremap _d  :set ft=diff<CR>

" }}}
" Insert Mode Completion {{{

inoremap <c-l><c-l> <c-x><c-l>
inoremap <c-f> <c-x><c-f>
inoremap <c-]> <c-x><c-]>

" }}}
" Quick editing {{{
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>ez :vsplit ~/.zshrc<cr>

" }}}

" Swap two words
nmap <silent> gw :s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR>`'

" }}}
" Searching and movement -------------------------------------------------- {{{

" Use sane regexes.
nnoremap / /\v
vnoremap / /\v

set showmatch
set gdefault
set hlsearch                                     " highlight matches
set incsearch                                    " incremental searching
set ignorecase                                   " searches are case insensitive...
set smartcase                                    " ... unless they contain at least one capital letter

set scrolloff=3
set sidescroll=1
set sidescrolloff=10

set virtualedit+=block

noremap <leader><space> :noh<cr>:call clearmatches()<cr>

" bracket match using tab
map <tab> %

" Made D behave
nnoremap D d$

" Don't move on *
nnoremap * *<c-o>

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

" Same when jumping around
nnoremap g; g;zz
nnoremap g, g,zz

" Easier to type, and I never use the default behavior.
noremap H ^
noremap L $
vnoremap L g_

" Heresy
inoremap <c-a> <esc>I
inoremap <c-e> <esc>A

" Open a Quickfix window for the last search.
nnoremap <silent> <leader>? :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

" Ack for the last search.
nnoremap <silent> <leader>/ :execute "Ack! '" . substitute(substitute(substitute(@/, "\\\\<", "\\\\b", ""), "\\\\>", "\\\\b", ""), "\\\\v", "", "") . "'"<CR>

" Fix linewise visual selection of various text objects
nnoremap VV V
nnoremap Vit vitVkoj
nnoremap Vat vatV
nnoremap Vab vabV
nnoremap VaB vaBV

" Toggle "keep current line in the center of the screen" mode
nnoremap <leader>C :let &scrolloff=999-&scrolloff<cr>

" Directional Keys {{{

" It's 2012.
noremap j gj
noremap k gk
noremap gj j
noremap gk k

" Easy buffer navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" Vertical window split
noremap <leader>v <C-w>v

" Horizontal window split 
noremap <leader>s <C-w>s


" }}}
" Highlight word {{{

nnoremap <silent> <leader>hh :execute 'match InterestingWord1 /\<<c-r><c-w>\>/'<cr>
nnoremap <silent> <leader>h1 :execute 'match InterestingWord1 /\<<c-r><c-w>\>/'<cr>
nnoremap <silent> <leader>h2 :execute '2match InterestingWord2 /\<<c-r><c-w>\>/'<cr>
nnoremap <silent> <leader>h3 :execute '3match InterestingWord3 /\<<c-r><c-w>\>/'<cr>

" }}}
" Visual Mode */# from Scrooloose {{{

function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endfunction

vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR><c-o>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR><c-o>

" }}}
" List navigation {{{

nnoremap <left>  :cprev<cr>zvzz
nnoremap <right> :cnext<cr>zvzz
nnoremap <up>    :lprev<cr>zvzz
nnoremap <down>  :lnext<cr>zvzz

" }}}

" }}}
" Plugin settings --------------------------------------------------------- {{{

" Ctrl-P {{{

let g:ctrlp_dont_split = 'NERD_tree_2'
let g:ctrlp_jump_to_buffer = 0
let g:ctrlp_map = '<leader><leader>'
let g:ctrlp_working_path_mode = 0
let g:ctrlp_match_window_reversed = 1
let g:ctrlp_split_window = 0
let g:ctrlp_max_height = 20
let g:ctrlp_extensions = ['tag']

let g:ctrlp_prompt_mappings = {
\ 'PrtSelectMove("j")':   ['<c-j>', '<down>', '<s-tab>'],
\ 'PrtSelectMove("k")':   ['<c-k>', '<up>', '<tab>'],
\ 'PrtHistory(-1)':       ['<c-n>'],
\ 'PrtHistory(1)':        ['<c-p>'],
\ 'ToggleFocus()':        ['<c-tab>'],
\ }

noremap <C-t> :CtrlP<CR>
inoremap <C-t> <ESC>:CtrlP<CR>

" }}}
" NERD Tree {{{ 
noremap  <F2> :NERDTreeToggle<cr>
inoremap <F2> <esc>:NERDTreeToggle<cr>

augroup ps_nerdtree
    au!

    au Filetype nerdtree setlocal nolist
    au Filetype nerdtree nnoremap <buffer> K :q<cr>
augroup END

let NERDTreeHighlightCursorline = 1
let NERDTreeMinimalUI = 0
let NERDTreeDirArrows = 1

" }}}
" NERD Commenter
" ---------------------FIXME------------------
nmap <C-/> :call NERDComment(0, "invert")<cr>
vmap <C-/> :call NERDComment(0, "invert")<cr>
" }}}

" }}}
" NERD Tree {{{ 
" Prompt for a command to run
map rp :PromptVimTmuxCommand

" Run last command executed by RunVimTmuxCommand
map rl :RunLastVimTmuxCommand

" Inspect runner pane
map ri :InspectVimTmuxRunner

" Close all other tmux panes in current window
map rx :CloseVimTmuxPanes

" Interrupt any command running in the runner pane
map rs :InterruptVimTmuxRunner

" }}}

" }}}
