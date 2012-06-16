" Basic options ----------------------------------------------------------- {{{

set showcmd " makes scrolling on CLI vim slow

" }}}


" CtrlP OS-X Menu remapping
macmenu &File.New\ Tab key=<D-S-t>
noremap <D-t> :CtrlP<CR>
inoremap <D-t> <ESC>:CtrlP<CR>
