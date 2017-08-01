if &compatible
    set nocompatible
endif

set runtimepath+=~/.vim_runtime

source ~/.vim_runtime/plugins.vim

source ~/.vim_runtime/basic.vim

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline_theme='onedark'

" Powerline
let g:airline_powerline_fonts = 1
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup

colorscheme torte

au BufRead,BufNewFile *.ts setlocal filetype=typescript
au Filetype javascript JsPreTmpl html
au Filetype typescript JsPreTmpl markdown
" for vim-typescript only
" au Filetype typescript syn clear foldBraces

autocmd BufNewFile,BufRead .tern-project setlocal filetype=json

source ~/.vim_runtime/neocomplete.vim

