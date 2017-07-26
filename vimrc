set runtimepath+=~/.vim_runtime
source ~/.vim_runtime/basic.vim

set ai
set wrap

" syntastic
"set statusline+=%#warningmsg#
"set statusline+={SyntasticStatuslineFlag()}
"set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
"airline
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline_theme='onedark'

" powerline
let g:airline_powerline_fonts = 1
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup

let NERDTreeShowHidden = 1

"youcompleteme
" since python3 is the default choice from Arch, that may cause 
" Ycm failed to run
" let g:ycm_server_python_interpreter = '/usr/bin/python2'
" let g:ycm_min_num_of_chars_for_completion = 2 
" let g:ycm_min_num_identifier_candidate_chars = 0
" let g:ycm_auto_trigger = 1

colorscheme torte 
" ==================================================================================================
" vundle config
set nocompatible              " be iMproved, required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'rdnetto/YCM-Generator'
Plugin 'jistr/vim-nerdtree-tabs'
" Plugin 'leafgarland/typescript-vim'
Plugin 'HerringtonDarkholme/yats.vim'
Plugin 'Quramy/vim-js-pretty-template'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'kannokanno/previm'
Plugin 'tyru/open-browser.vim'
Plugin 'raimondi/delimitmate'
" Plugin 'nsf/gocode', {'rtp': 'vim/'}
Plugin 'fatih/vim-go'
Plugin 'groenewege/vim-less'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'mattn/emmet-vim'
Plugin 'mattn/webapi-vim'
" Plugin 'python-mode/python-mode'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
" Plugin 'jelera/vim-javascript-syntax'
Plugin 'maksimr/vim-jsbeautify'
Plugin 'mru.vim'
Plugin 'sophacles/vim-bundle-mako'
Plugin 'jceb/vim-orgmode'
Plugin 'vimwiki/vimwiki'
Plugin 'thaerkh/vim-workspace'
Plugin 'ap/vim-css-color'
Plugin 'mhinz/vim-startify'
Plugin 'junegunn/goyo.vim'
Plugin 'neomake/neomake'
Plugin 'sbdchd/neoformat'
"Plugin 'mhinz/vim-signify'
Plugin 'lambdalisue/gina.vim'
Plugin 'airblade/vim-gitgutter'

" snippets
" Plugin 'SirVer/ultisnips'
" Plugin 'honza/vim-snippets'

Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-ragtag'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-rhubarb'
Plugin 'tpope/tpope-vim-abolish'
" Plugin 'tpope/vim-markdown', {'name': 'tpope-markdown'}
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-haml'
Plugin 'tpope/vim-bundler'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-rake'
Plugin 'tpope/vim-fireplace'
Plugin 'tpope/vim-scriptease'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-vinegar'

" syntax
" Plugin 'sheerun/vim-polyglot'
Plugin 'othree/javascript-libraries-syntax.vim'
Plugin 'ekalinin/dockerfile.vim'
Plugin 'rust-lang/rust.vim'
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'hail2u/vim-css3-syntax'
Plugin 'vim-ruby/vim-ruby'
Plugin 'vim-perl/vim-perl'
Plugin 'matt-deacalion/vim-systemd-syntax'
Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'
Plugin 'kchmck/vim-coffee-script'
Plugin 'pearofducks/ansible-vim'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'isobit/vim-caddyfile'
Plugin 'guns/vim-clojure-static'
Plugin 'rhysd/vim-crystal'
Plugin 'tpope/vim-cucumber'
Plugin 'dart-lang/dart-vim-plugin'
Plugin 'elmcast/elm-vim'
Plugin 'vim-erlang/vim-erlang-runtime'
Plugin 'derekwyatt/vim-scala'
Plugin 'slim-template/vim-slim'
Plugin 'elixir-lang/vim-elixir'
Plugin 'posva/vim-vue'
Plugin 'wlangstroth/vim-racket'
Plugin 'stephpy/vim-yaml'
Plugin 'stanangeloff/php.vim'

Plugin 'Shougo/neocomplete'
Plugin 'Shougo/vimshell.vim'
Plugin 'Shougo/neco-vim'
Plugin 'Shougo/neosnippet.vim'
Plugin 'Shougo/neosnippet-snippets'
Plugin 'Shougo/neoinclude.vim'
Plugin 'Shougo/context_filetype.vim'
Plugin 'Shougo/unite.vim'
Plugin 'Shougo/denite.nvim'

" completions
Plugin 'artur-shaik/vim-javacomplete2'
Plugin 'davidhalter/jedi-vim'
Plugin 'ternjs/tern_for_vim'
Plugin 'othree/csscomplete.vim'
Plugin 'Quramy/tsuquyomi'
Plugin 'shawncplus/phpcomplete.vim'
Plugin 'racer-rust/vim-racer'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
" plugin from http://vim-scripts.org/vim/scripts.html
" Git plugin not hosted on GitHub
" git repos on your local machine (i.e. when working on your own plugin)
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
syntax enable
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
" ======================================================================================"

" delimitMate
let delimitMate_expand_cr = 2
let delimitMate_smart_quotes = 1
let delimitMate_smart_matchpairs = 1
let delimitMate_balance_matchpairs = 1
let delimitMate_expand_space = 1

au BufRead,BufNewFile *.ts setlocal filetype=typescript
au Filetype javascript JsPreTmpl html
au Filetype typescript JsPreTmpl markdown
" for vim-typescript only 
" au Filetype typescript syn clear foldBraces

" neocomplete
"Note: This option must be set in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
let g:acp_enableAtStartup = 1
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1

let g:neocomplete#enable_camel_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
            \ 'default' : '',
            \ 'vimshell' : $HOME.'/.vimshell_hist',
            \ 'scheme' : $HOME.'/.gosh_completions'
            \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

if !exists('g:neocomplete#force_omni_input_patterns')
	  let g:neocomplete#force_omni_input_patterns = {}
endif

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
" conflict with delimitmate expand_cr
" inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>

function! s:my_cr_function()
    return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
    " For no inserting <CR> key.
    "return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction

function! s:check_back_space() "{{{
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}

function! Tab_Snippet_Complete()
  let snippet = UltiSnips#ExpandSnippet()
  if g:ulti_expand_res > 0
    return snippet
  endif
  if <SID>check_back_space()
    return "\<TAB>"
  endif
  let manualcomplete = neocomplete#start_manual_complete()
  return manualcomplete
endfunction

" Recommended key-mappings.
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ neocomplete#start_manual_complete()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" :
        \ "\<S-TAB>"

" inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

"" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.php = 
    \ '\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.go = '[^.[:digit:] *\t]\.\w*'
let g:neocomplete#sources#omni#input_patterns.java = '\h\w*\.\w*'


" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=tern#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType java setlocal omnifunc=javacomplete#Complete
autocmd Filetype haskell setlocal omnifunc=necoghc#omnifunc
autocmd Filetype python setlocal omnifunc=jedi#completions
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#smart_auto_mappings = 0
let g:neocomplete#force_omni_input_patterns.python =
	\ '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'

let g:neocomplete#force_omni_input_patterns.typescript = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplete#force_omni_input_patterns.javascript = '[^. \t]\.\w*'


" vim-javascript
let g:javascript_plugin_jsdoc = 1
" javascript-libraries-syntax
let g:used_javascript_libs = 'jquery,react,vue,angularjs,angularui,angularuirouter'

autocmd BufNewFile,BufRead .tern-project setlocal filetype=json

" python-mode
"let g:pymode_rope_lookup_project = 1
"let g:pymode_rope_complete_on_dot = 1
"let g:pymode_rope_autoimport = 1
