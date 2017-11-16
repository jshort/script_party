"###### 1) Common Settings #####################################################
set directory=~/.vim/tmp//,~/tmp//,/tmp//
filetype on
filetype plugin on
filetype indent on
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


"###### 2) Color Scheme ########################################################
syntax on
colorscheme koehler
"###############################################################################


"###### 3) Configuration/Variables/Commands ####################################
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
let g:ctrlp_working_path_mode = 'w'
" grep config
command! -nargs=+ Grep execute 'silent AsyncRun grep -nRS --exclude-dir={target,build,.git,.svn} <args>'
" help command for full window
command! -nargs=+ Help execute 'silent help <args>' | only
augroup vimrc
  " automatically open quickfix window if not already
  autocmd User AsyncRunStart call asyncrun#quickfix_toggle(10, 1)
  " set asyncrun status
  autocmd VimEnter * let g:airline_section_error = airline#section#create_right(['%{g:asyncrun_status}'])
augroup END
"###############################################################################


"###### 4) Highlighting ########################################################
set lcs=eol:$,tab:>-,trail:#
"" set listchars=tab:>-,trail:-
" Turn on search highlighting (in progress and complete)
set incsearch
set hlsearch
" Search and line number highlighting colors
highlight Search ctermbg=57
highlight LineNr ctermfg=46
" Highlight trailing whitespace in red
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
"###############################################################################


"###### 5) Global Tab/Space config #############################################
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent
set smartindent
set pastetoggle=<F2>
"###############################################################################


"###### 6) Filetype specific configuration #####################################
autocmd FileType c,sh,ruby,python,java autocmd BufWrite <buffer> :call DeleteTrailingWS()
autocmd FileType python setlocal sw=4 sts=4 expandtab tw=80  fo+=t
autocmd FileType sh     setlocal sw=2 sts=2 expandtab tw=80  fo+=t
autocmd FileType ruby   setlocal sw=2 sts=2 expandtab tw=80  fo+=t
autocmd FileType go     setlocal sw=8 sts=8 expandtab
autocmd FileType java   setlocal sw=4 sts=4 expandtab tw=120 fo+=t
"###############################################################################


"###### 7) Key (re)mappings ####################################################
" Change leader to space key
let mapleader = "\<Space>"
" <Esc> to jj to keep fingers on home keys
inoremap jj <Esc>
" Paste from system clipboard
inoremap vv <C-r>*
" Turn off search highlighting
nnoremap <silent> <leader>j :nohlsearch<CR>
" Toggle crosshairs
nnoremap <silent> <leader>k :call CrosshairToggle()<CR>
" To open a new empty buffer
nmap <leader>t :enew<CR>
" Move to the next buffer
nmap <leader>l :bnext<CR>
" Move to the previous buffer
nmap <leader>h :bprevious<CR>
" Close the current buffer and move to the previous one
nmap <leader>q :bprevious <Bar> bdelete #<CR>
" Update current buffer if it has changes (think cmd-s to save)
nmap <leader>s :update<CR>
" Exit command/search history
nmap <leader>c <C-c><C-c>
" Close quickfix (think 'done')
nmap <leader>d :ccl <CR>
" Open quickfix
nmap <leader>o :copen <CR>
" write file as sudo if you forgot to start vim with sudo
cmap w!! write !sudo tee > /dev/null %
" Mapping to automatically expand to the path of the current buffer
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
" Mappings for up/down in command mode for scrolling through history
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>
" Grep recursively in cwd for the current word using custom Grep
nnoremap gr :Grep <cword> .<CR>
" Java getter/setter generation
map ggs ^mawv/ <CR>"ty/ <CR>wvwh"ny/setters<CR>$a<CR><ESC>xxa<CR>public void <Esc>"npbiset<Esc>l~ea(<Esc>"tpa<Esc>"npa) {<CR><Tab>this.<Esc>"npa = <Esc>"npa;<CR>}<Esc>=<CR><ESC>/getters<CR>$a<CR><ESC>xxa<CR>public <Esc>"tpa<Esc>"npbiget<Esc>l~ea() {<CR><Tab>return <Esc>"npa;<CR>}<Esc>=<CR><Esc>`ak


"###### 8) Cross hairs #########################################################
set cursorline
set cursorcolumn
hi CursorColumn ctermbg=243
hi CursorLine   ctermbg=243 cterm=NONE ctermfg=15
"###############################################################################


"###### 9) Functions ##########################################################
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


"###### 10) Macros #############################################################
" Swap current line with one above
let @a = 'ddp'
let @b = 'mz:%s/mipselled/mispelled/g`z'
" Surround word by spaces
let @s = 'ciw  P'
"###############################################################################
