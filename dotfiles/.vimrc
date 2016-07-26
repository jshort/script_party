" Line numbers, wrap, ruler, search highlighting
set number
hi LineNr ctermfg=green
set wrap
set ruler
set incsearch
set hlsearch
hi Search ctermbg=Blue

" Syntax highlighting
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

" Key (re)mappings
inoremap jj <ESC>
let mapleader = "\<Space>"
map <silent> <leader>l :noh<cr>
nnoremap <silent> <leader>h :call HighlightToggle()<cr>
" vnoremap <ESC> <C-c>

" Cross hairs
set cursorline
set cursorcolumn
" hi Cursor ctermbg=15 ctermfg=8
hi CursorColumn ctermbg=8 "8 = dark gray"
" hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white
hi CursorLine cterm=NONE ctermbg=8 ctermfg=15 "8 = dark gray, 15 = white

" Filetype specific configuration
autocmd FileType sh,ruby,python,java autocmd BufWrite <buffer> :call DeleteTrailingWS()
autocmd BufRead,BufNewFile *.go setfiletype go
autocmd FileType python setlocal sw=4 sts=4 expandtab
autocmd FileType sh     setlocal sw=4 sts=4 expandtab
autocmd FileType ruby   setlocal sw=2 sts=2 expandtab
autocmd FileType go     setlocal sw=8 sts=8 expandtab
autocmd FileType java   setlocal sw=4 sts=4 expandtab

" Variables
let g:netrw_liststyle=3
set timeoutlen=1000 ttimeoutlen=0

" Functions
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

let g:should_highlight = 1
func! HighlightToggle()
  if g:should_highlight
    setlocal cursorline!
    setlocal cursorcolumn!
    let g:should_highlight = 0
  else
    setlocal cursorline
    setlocal cursorcolumn
    let g:should_highlight = 1
  endif
endfunc

" Macros
let @a='ddp'
let @b='mz:s/cursor/blah/g`z'
