"###### 1) Plugins #############################################################
call plug#begin('~/.vim/plugged')

Plug 'Raimondi/delimitMate'
Plug 'bronson/vim-visual-star-search'
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'junegunn/fzf'
Plug 'skywind3000/asyncrun.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'vim-airline/vim-airline'
Plug 'yangmillstheory/vim-snipe'

Plug 'artur-shaik/vim-javacomplete2'
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
endif

call plug#end()

"###### 2) Common Settings #####################################################
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


"###### 3) Color Scheme ########################################################
syntax on
colorscheme koehler
highlight Pmenu    ctermfg=9   ctermbg=16  gui=bold
highlight PmenuSel ctermfg=16  ctermbg=14  gui=bold
"###############################################################################


"###### 4) General Configuration/Variables/Commands ############################
" Set bash as the default shell syntax
let g:bash_is_sh = 1
let g:should_highlight = 1
" vim-airline config (always show status and tabline)
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
" Set netrw file listing style
let g:netrw_liststyle = 0
let g:netrw_hide = 1
set wildignore=*.o,*.so,*.a,*.pyc,*.swp,*/.git/*,*.class,*/target/*,*/.idea/*,*.iml
" This speeds up <Esc> in visual mode
set timeoutlen=1000 ttimeoutlen=0
" delimitMate <Space> expansion
let delimitMate_expand_space = 1
" help command for full window
command! -nargs=+ Help execute 'silent help <args>' | only
" set asyncrun status
let g:airline_section_error = airline#section#create_right(['%{g:asyncrun_status}'])
augroup vimrc
  " automatically open quickfix window if not already
  autocmd User AsyncRunStart call asyncrun#quickfix_toggle(12, 1)
augroup END
"###############################################################################


"###### 5) Plugin Configuration/Variables/Commands #############################
" deoplete config
if has('nvim')
  let g:deoplete#enable_at_startup = 1
  call deoplete#custom#option('omni_patterns', {'java':['[^. *\t]\.\w*','@\w\+']})
endif
" vim-javacomplete2 config
let g:JavaComplete_ImportSortType = 'packageName'
let g:JavaComplete_ImportOrder = ['java.', 'javax.', 'org.', 'com.', 'net.']
" let g:JavaComplete_InsertImports = 0
" FZF config
let $FZF_DEFAULT_COMMAND = $HOME."/.vim/fzfcmd"
if has('nvim')
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
endif
" vim-snipe highlighting
let g:snipe_highlight_cterm256_color = 'cyan'
" go-vim settings
if has("nvim")
  au FileType go nmap <leader>r <Plug>(go-run-tab)
else
  au FileType go nmap <leader>r <Plug>(go-run)
endif
let g:go_term_mode = "split"
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_generate_tags = 1
"###############################################################################


"###### 6) Highlighting ########################################################
set listchars=eol:$,tab:>-,trail:#
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


"###### 7) Global Tab/Space config #############################################
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent
set smartindent
set pastetoggle=<F2>
"###############################################################################


"###### 8) Filetype specific configuration #####################################
autocmd FileType * autocmd BufWrite <buffer> :call DeleteTrailingWS()
autocmd FileType python setlocal sw=4 sts=4 expandtab tw=80  fo+=t nosmartindent
autocmd FileType sh     setlocal sw=2 sts=2 expandtab tw=80  fo+=t
autocmd FileType ruby   setlocal sw=2 sts=2 expandtab tw=80  fo+=t
autocmd FileType go     setlocal noexpandtab tabstop=4 shiftwidth=4
autocmd FileType java   setlocal sw=4 sts=4 expandtab tw=120 fo+=t
autocmd FileType java   setlocal omnifunc=javacomplete#Complete
autocmd FileType xml    setlocal sw=2 sts=2 expandtab tw=120 fo+=t
"###############################################################################


"###### 9) Key (re)mappings ####################################################
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
" Open quickfix
nmap <leader>o :copen <CR>
" Close quickfix (think 'done')
nmap <leader>d :ccl <CR>
" write file as sudo if you forgot to start vim with sudo
cmap w!! write !sudo tee > /dev/null %
" Mapping to automatically expand to the path of the current buffer
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
" Mappings for up/down in command mode for scrolling through history
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>
" ctrlp like mapping for fzf
nnoremap <C-p> :FZF<CR>
" Grep recursively in cwd for the current word using custom Grep
nnoremap gr :Grep <cword> .<CR>
" Java getter/setter generation
map ggs ^mawv/ <CR>"ty/ <CR>wvwh"ny/setters<CR>$a<CR><ESC>xxa<CR>public void <Esc>"npbiset<Esc>l~ea(<Esc>"tpa<Esc>"npa) {<CR><Tab>this.<Esc>"npa = <Esc>"npa;<CR>}<Esc>=<CR><ESC>/getters<CR>$a<CR><ESC>xxa<CR>public <Esc>"tpa<Esc>"npbiget<Esc>l~ea() {<CR><Tab>return <Esc>"npa;<CR>}<Esc>=<CR><Esc>`ak
" vim-snipe mapping
map <leader><leader>f <Plug>(snipe-f)
" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"


"###### 10) Cross hairs #########################################################
set cursorline
set cursorcolumn
hi CursorColumn ctermbg=243
hi CursorLine   ctermbg=243 cterm=NONE ctermfg=15
"###############################################################################


"###### 11) Functions ##########################################################
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


"###### 12) Macros #############################################################
" Swap current line with one above
let @a = 'ddp'
let @b = 'mz:%s/mipselled/mispelled/g`z'
" Surround word by spaces
let @s = 'ciw  P'
"###############################################################################

"###### 13) Custom Commands ####################################################
" grep config
command! -nargs=+ Grep execute 'silent AsyncRun grep -nRS --exclude-dir={target,build,.git,.svn} <args>'
" maven build
command! MCI execute 'AsyncRun mvn clean install'
command! MC execute 'AsyncRun mvn clean'
