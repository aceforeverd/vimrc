if &compatible 
    set nocompatible
endif

set runtimepath+=~/.vim_runtime

source ~/.vim_runtime/plugins.vim

source ~/.vim_runtime/basic.vim

" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Airline
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline_theme='onedark'

" Powerline
let g:airline_powerline_fonts = 1
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup

"youcompleteme
" let g:ycm_server_python_interpreter = '/usr/bin/python2'
" let g:ycm_min_num_of_chars_for_completion = 2 
" let g:ycm_min_num_identifier_candidate_chars = 0
" let g:ycm_auto_trigger = 1

set ai
set wrap
colorscheme torte 

" delimitMate
let delimitMate_expand_cr = 2
" let delimitMate_smart_quotes = 1
" let delimitMate_smart_matchpairs = 1
let delimitMate_balance_matchpairs = 1
let delimitMate_expand_space = 1

au BufRead,BufNewFile *.ts setlocal filetype=typescript
au Filetype javascript JsPreTmpl html
au Filetype typescript JsPreTmpl markdown
" for vim-typescript only 
" au Filetype typescript syn clear foldBraces

" utilsnips
let g:UltiSnipsExpandTrigger = "<leader>et"
let g:UltiSnipsJumpForwardTrigger = "<c-b>"
let g:UltiSnipsJumpBackwardTrigger = "<c-z>"
" split window while :UtilSnipsEdit
let g:UltiSnipsEditSplit = "vertical"


" vim-javascript
let g:javascript_plugin_jsdoc = 1
" javascript-libraries-syntax
let g:used_javascript_libs = 'jquery,react,vue,angularjs,angularui,angularuirouter'

autocmd BufNewFile,BufRead .tern-project setlocal filetype=json

source ~/.vim_runtime/neocomplete.vim

