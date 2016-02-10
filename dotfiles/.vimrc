set number
set wrap
set ruler

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
