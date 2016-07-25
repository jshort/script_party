set number
highlight LineNr ctermfg=green
set wrap
set ruler
set incsearch
set hlsearch
hi Search ctermbg=Blue

syntax on
filetype plugin on
filetype indent on
" set listchars=tab:>-,trail:-
set lcs=eol:$,tab:>-,trail:#

" Global Tab/Space config
set shiftwidth=2
set softtabstop=2
set expandtab
set ai "Auto indent
set si "Smart indent
set pastetoggle=<F2>

" Key mappings
inoremap jj <ESC>
let mapleader = "\<Space>"

" Cross hairs
set cursorline
set cursorcolumn

" hi Cursor ctermbg=15 ctermfg=8
hi CursorColumn ctermbg=8 "8 = dark gray"
" hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white
hi CursorLine cterm=NONE ctermbg=8 ctermfg=15 "8 = dark gray, 15 = white

func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

"autocmd BufWrite *.sh :call DeleteTrailingWS()
autocmd FileType sh,ruby,python autocmd BufWrite <buffer> :call DeleteTrailingWS()
autocmd FileType python setlocal sw=4 sts=4 expandtab
autocmd FileType sh setlocal sw=4 sts=4 expandtab
autocmd FileType ruby setlocal sw=2 sts=2 expandtab
autocmd FileType go setlocal sw=8 sts=8 expandtab

au BufRead,BufNewFile *.go setfiletype go

nnoremap <leader>h :call HighlightToggle()<cr>
let g:should_highlight = 1
function! HighlightToggle()
    if g:should_highlight
      setlocal cursorline!
      setlocal cursorcolumn!
      let g:should_highlight = 0
    else
      setlocal cursorline
      setlocal cursorcolumn
      let g:should_highlight = 1
    endif
endfunction

" Macros
let @a='ddp'
let @b=':s/cursor/blah/'
