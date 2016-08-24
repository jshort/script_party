"###### 1) Pathogen ############################################################
execute pathogen#infect()
"###############################################################################

"###### 2) Common Settings #####################################################
" Turn on line numbers, word wrap, and ruler
set backspace=2
set noshowmode
set number
set wrap
set ruler
set scrolloff=2
set history=250
" This allows buffers to be hidden if a buffer has been modified.
set hidden
"###############################################################################


"###### 3) Color Scheme ########################################################
colo peachpuff
"###############################################################################


"###### 4) Configuration/Variables/Commands ####################################
let g:should_highlight = 1
" vim-airline config (always show status and tabline)
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
" Set netrw file listing style
let g:netrw_liststyle = 0
let g:netrw_hide = 1
set wildignore=*.swp,.git/
" This speeds up <Esc> in visual mode
set timeoutlen=1000 ttimeoutlen=0
" delimitMate <Space> expansion
let delimitMate_expand_space = 1
" ctrlp settings
let g:ctrlp_show_hidden = 1
" grep config
let &grepprg = 'grep -n -R -s --exclude-dir={target,build,.git,.svn}'
command! -nargs=+ Grep execute 'silent grep! <args>' | copen 15
" help command for full window
command! -nargs=+ Help execute 'silent help <args>' | only
"###############################################################################


"###### 5) Highlighting ########################################################
syntax on
filetype plugin on
filetype indent on
"" set listchars=tab:>-,trail:-
set lcs=eol:$,tab:>-,trail:#
" Highlight trailing whitespace in red
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
" Turn on search highlighting (in progress and complete)
set incsearch
set hlsearch
" Search and line number highlighting colors
autocmd ColorScheme * hi Search ctermbg=Blue
autocmd ColorScheme * hi LineNr ctermfg=green
"###############################################################################


"###### 6) Global Tab/Space config #############################################
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent
set smartindent
set pastetoggle=<F2>
"###############################################################################


"###### 7) Filetype specific configuration #####################################
autocmd FileType sh,ruby,python,java autocmd BufWrite <buffer> :call DeleteTrailingWS()
autocmd BufRead,BufNewFile *.go setfiletype go
autocmd FileType python setlocal sw=4 sts=4 expandtab tw=80  fo+=t
autocmd FileType sh     setlocal sw=2 sts=2 expandtab tw=80  fo+=t
autocmd FileType ruby   setlocal sw=2 sts=2 expandtab tw=80  fo+=t
autocmd FileType go     setlocal sw=8 sts=8 expandtab
autocmd FileType java   setlocal sw=4 sts=4 expandtab tw=120 fo+=t
"###############################################################################


"###### 8) Key (re)mappings ####################################################
" <Esc> to jj to keep fingers on home keys
inoremap jj <Esc>
" Change leader to space key
let mapleader = "\<Space>"
" Turn off search highlighting
map <silent> <leader>j :noh<CR>
" Toggle crosshairs
nnoremap <silent> <leader>k :call CrosshairToggle()<CR>
" To open a new empty buffer
" This replaces :tabnew which I used to bind to this mapping
nmap <leader>t :enew<CR>
" Move to the next buffer
nmap <leader>l :bnext<CR>
" Move to the previous buffer
nmap <leader>h :bprevious<CR>
" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <leader>q :bp <Bar> bd #<CR>
" Mapping to automatically expand to the path of the current buffer
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
" Update current buffer if it has changes (think cmd-s to save)
nmap <leader>s :update<CR>
" Exit command/search history
nmap <leader>c <C-c><C-c>


"###### 9) Cross hairs #########################################################
set cursorline
set cursorcolumn
" hi Cursor ctermbg=15 ctermfg=8
hi CursorColumn ctermbg=8 "8 = dark gray"
" hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white
hi CursorLine cterm=NONE ctermbg=8 ctermfg=15 "8 = dark gray, 15 = white
"###############################################################################


"###### 10) Functions ##########################################################
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

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
"###############################################################################


"###### 11) Macros #############################################################
" Swap current line with one above
let @a = 'ddp'
let @b = 'mz:%s/mipselled/mispelled/g`z'
"###############################################################################
