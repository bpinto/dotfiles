" Start vim in fullscreen mode
set fuoptions=maxvert,maxhorz
au GUIEnter * set fullscreen

" Set Inconsolata font
set guifont=Inconsolata-dz\ for\ Powerline:h12

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CtrlP OS-X Menu remapping
macmenu &File.New\ Tab key=<D-S-t>
noremap <D-t> :CtrlP<CR>
inoremap <D-t> <ESC>:CtrlP<CR>

