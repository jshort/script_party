" ##### Pathogen #####
execute pathogen#infect()

colo peachpuff

" ##### Configuration/Variables #####
" vim-airline config (always show status and tabline)
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
" Set netrw file listing style
let g:netrw_liststyle=3
" This speeds up <ESC> in visual mode
set timeoutlen=1000 ttimeoutlen=0
" delimitMate <Space> expansion
let delimitMate_expand_space = 1


" ##### Common Settings #####
" Turn on line numbers, word wrap, and ruler
set backspace=2
set noshowmode
set number
set wrap
set ruler
" Turn on search highlighting (in progress and complete)
set incsearch
set hlsearch
" Search and line number highlighting colors
autocmd ColorScheme * hi Search ctermbg=Blue
autocmd ColorScheme * hi LineNr ctermfg=green


" ##### Syntax highlighting #####
syntax on
filetype plugin on
filetype indent on
" set listchars=tab:>-,trail:-
set lcs=eol:$,tab:>-,trail:#
" Highlight trailing whitespace in red
:highlight ExtraWhitespace ctermbg=red guibg=red
:match ExtraWhitespace /\s\+$/


" ##### Global Tab/Space config #####
set shiftwidth=2
set softtabstop=2
set expandtab
set ai "Auto indent
set si "Smart indent
set pastetoggle=<F2>


" ##### Key (re)mappings #####
" <ESC> to jj to keep fingers on home keys
inoremap jj <ESC>
" Change leader to space key
let mapleader = "\<Space>"
" Turn off search highlighting with leader l
map <silent> <leader>j :noh<cr>
" Toggle crosshairs
nnoremap <silent> <leader>k :call CrosshairToggle()<cr>
" This mapping causes arrow keys to not work in visual mode, investigate
" vnoremap <ESC> <C-c>
" This allows buffers to be hidden if you've modified a buffer.
" This is almost a must if you wish to use buffers in this way.
set hidden
" To open a new empty buffer
" This replaces :tabnew which I used to bind to this mapping
nmap <leader>T :enew<cr>
" Move to the next buffer
nmap <leader>l :bnext<CR>
" Move to the previous buffer
nmap <leader>h :bprevious<CR>
" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <leader>q :bp <BAR> bd #<CR>
" Show all open buffers and their status
nmap <leader>bl :ls<CR>


" ##### Cross hairs #####
set cursorline
set cursorcolumn
" hi Cursor ctermbg=15 ctermfg=8
hi CursorColumn ctermbg=8 "8 = dark gray"
" hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white
hi CursorLine cterm=NONE ctermbg=8 ctermfg=15 "8 = dark gray, 15 = white


" ##### Filetype specific configuration #####
autocmd FileType sh,ruby,python,java autocmd BufWrite <buffer> :call DeleteTrailingWS()
autocmd BufRead,BufNewFile *.go setfiletype go
autocmd FileType python setlocal sw=4 sts=4 expandtab tw=80 fo+=t
autocmd FileType sh     setlocal sw=2 sts=2 expandtab tw=80 fo+=t
autocmd FileType ruby   setlocal sw=2 sts=2 expandtab tw=80 fo+=t
autocmd FileType go     setlocal sw=8 sts=8 expandtab
autocmd FileType java   setlocal sw=4 sts=4 expandtab tw=120 fo+=t


" ##### Functions #####
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

let g:should_highlight = 1
func! CrosshairToggle()
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


" ##### Macros #####
" Swap current line with one above
let @a='ddp'
let @b='mz:s/cursor/blah/g`z'
