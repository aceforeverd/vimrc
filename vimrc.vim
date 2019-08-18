set nocompatible

" pathogen
" add plugins in ~/.vim/bundle
" execute pathogen#infect('~/.vim/bundle/{}')

" vim plug
" ============================================================================================
call plug#begin('~/.vim-commons/pkgs')

Plug 'dense-analysis/ale'
Plug 'airblade/vim-gitgutter'
Plug 'rhysd/vim-grammarous'
Plug 'vim-scripts/a.vim'
Plug 'idanarye/vim-vebugger'
Plug 'tpope/vim-fugitive'
Plug 'joereynolds/SQHell.vim'
Plug 'sjl/splice.vim'
Plug 'junegunn/vader.vim'
Plug 'iamcco/markdown-preview.nvim', {
            \ 'do': 'cd app & yarn install',
            \ 'for': 'markdown'
            \}
Plug 'sakhnik/nvim-gdb'
let g:nvimgdb_disable_start_keymaps = 1
Plug 'sheerun/vim-polyglot'
let g:polyglot_disabled = ['javascript', 'typescript']
let g:vim_json_syntax_conceal = 1

if executable('composer')
    Plug 'phpactor/phpactor', {
                \ 'do': 'composer install',
                \ 'for': 'php',
                \ 'dir': $HOME . '/.phpactor',
                \ }
    augroup gp_phpactor
        autocmd!
        " Include use statement
        autocmd FileType php nmap <Leader>pu :call phpactor#UseAdd()<CR>

        " Invoke the context menu
        autocmd FileType php nmap <Leader>pm :call phpactor#ContextMenu()<CR>

        " Goto definition of class or class member under the cursor
        autocmd FileType php nmap <c-]> :call phpactor#GotoDefinition()<CR>

        " Transform the classes in the current file
        autocmd FileType php nmap <Leader>pt :call phpactor#Transform()<CR>

        " Generate a new class (replacing the current file)
        autocmd FileType php nmap <Leader>pc :call phpactor#ClassNew()<CR>

        " Extract method from selection
        autocmd FileType php vmap <silent><Leader>pe :<C-U>call phpactor#ExtractMethod()<CR>
    augroup END
    " Plug 'roxma/ncm-phpactor', {'for': 'php'}
    Plug 'roxma/LanguageServer-php-neovim', {
                \ 'do': 'composer install && composer run-script parse-stubs',
                \ 'for': 'php'
                \ }
endif

Plug 'vim-pandoc/vim-pandoc'
Plug 'mzlogin/vim-markdown-toc', {'for': 'markdown'}
Plug 'beloglazov/vim-online-thesaurus'
Plug 'chrisbra/unicode.vim'

function! BuildComposer(info)
    if a:info.status !=? 'unchanged' || a:info.force
        if has('nvim')
            !cargo build --release
        else
            !cargo build --release --no-default-features --features json-rpc
        endif
    endif
endfunction

Plug 'autozimu/LanguageClient-neovim', {
            \ 'branch': 'next',
            \ 'do': 'bash install.sh',
            \ }
let g:LanguageClient_autoStart = 0
let g:LanguageClient_selectionUI = 'fzf'
let g:LanguageClient_loadSettings = 1
let g:LanguageClient_serverCommands = {
            \ 'rust': ['rustup', 'run', 'beta', 'rls'],
            \ 'typescript': ['javascript-typescript-stdio'],
            \ 'javascript': ['javascript-typescript-sdtio'],
            \ 'go': ['gopls'],
            \ 'yaml': ['/usr/bin/node', $HOME . '/.npm_global/lib64/node_modules/yaml-language-server/out/server/src/server.js', '--stdio'],
            \ 'css': ['css-language-server', '--stdio'],
            \ 'sass': ['css-language-server', '--stdio'],
            \ 'less': ['css-language-server', '--stdio'],
            \ 'dockerfile': ['docker-langserver', '--stdio'],
            \ 'reason': ['ocaml-language-server', '--stdio'],
            \ 'ocaml': ['ocaml-language-server', '--stdio'],
            \ 'vue': ['vls'],
            \ 'lua': ['lua-lsp'],
            \ 'ruby': ['language_server-ruby'],
            \ 'c': ['clangd', '-background-index'],
            \ 'cpp': ['clangd', '-background-index'],
            \ 'python': ['pyls'],
            \ 'dart': ['dart_language_server', '--force_trace_level=off'],
            \ 'haskell': ['hie', '--lsp'],
            \ 'sh': [ 'bash-language-server', 'start' ],
            \ }
nnoremap <silent> gK :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

if executable('cargo')
    Plug 'euclio/vim-markdown-composer', {
                \ 'do': function('BuildComposer'),
                \ 'for': 'markdown',
                \ }
endif

Plug 'neomake/neomake'
Plug 'hardenedapple/vsh'
Plug 'Konfekt/Fastfold'
let g:fastfold_fold_command_suffixes = []
let g:fastfold_fold_movement_commands = []

call plug#end()

if !has('nvim')
    let g:dein_repo = $HOME . '/.vim/dein'
    let g:vimrc = $HOME . '/.vimrc'
else
    let g:dein_repo = $HOME . '/.config/nvim/dein'
    let g:vimrc = $HOME . '/.config/nvim/init.vim'
endif

let g:dein_path = g:dein_repo . '/repos/github.com/Shougo/dein.vim'
let &runtimepath = &runtimepath . ',' . g:dein_path

let g:dein#install_process_timeout = 180
let g:dein#install_process_type = 'tabline'

" let $NVIM_NODE_LOG_FILE = '/tmp/nvim-node.log'
" let $NVIM_NODE_LOG_LEVEL = 'info'

if dein#load_state(g:dein_repo)
    call dein#begin(g:dein_repo)
    call dein#add(g:dein_path)

    if !has('nvim')
        " optional plugins for vim
        call dein#add('roxma/nvim-yarp')
        call dein#add('roxma/vim-hug-neovim-rpc')

        call dein#add('Quramy/tsuquyomi', {'for': 'typescript'})
        let g:tsuquyomi_completion_detail = 1
        let g:tsuquyomi_single_quote_import = 1
    else
        " optional plugins for neovim
        call dein#add('mhartington/nvim-typescript', {
                    \ 'on_ft': 'typescript',
                    \ 'build': './install.sh',
                    \ })

        call dein#add('kassio/neoterm')
        call dein#add('fszymanski/fzf-gitignore')
        call dein#add('jodosha/vim-godebug', {'on_ft': 'go'})
        " Repl
        call dein#add('hkupty/iron.nvim')
    endif
    call dein#add('wsdjeg/dein-ui.vim')
    call dein#add('Shougo/vimproc.vim', {'build': 'make'})
    call dein#add('Shougo/deoplete.nvim')
    call dein#add('Shougo/neoinclude.vim')
    call dein#add('Shougo/context_filetype.vim')
    call dein#add('Shougo/neco-syntax')
    call dein#add('Shougo/vinarise.vim')
    call dein#add('Shougo/unite.vim')
    call dein#add('Shougo/denite.nvim')
    call dein#add('Shougo/neomru.vim')
    call dein#add('Shougo/vimshell.vim')
    call dein#add('Shougo/defx.nvim')
    call dein#add('kristijanhusak/defx-icons')
    call dein#add('Shougo/neco-vim')
    call dein#add('Shougo/neoyank.vim')
    call dein#add('Shougo/echodoc.vim')
    call dein#add('Shougo/neossh.vim')
    call dein#add('Shougo/deoplete-lsp')
    call dein#add('Shougo/deol.nvim')

    call dein#add('ujihisa/neco-look')

    call dein#add('tpope/vim-endwise')
    call dein#add('tpope/vim-commentary')
    call dein#add('tpope/vim-surround')
    call dein#add('tpope/vim-ragtag')
    call dein#add('tpope/vim-dispatch')
    call dein#add('tpope/vim-rhubarb')
    call dein#add('tpope/tpope-vim-abolish')
    call dein#add('tpope/vim-repeat')
    call dein#add('tpope/vim-bundler')
    call dein#add('tpope/vim-rails', {'on_ft': 'ruby'})
    call dein#add('tpope/vim-rake', {'on_ft': 'ruby'})
    call dein#add('tpope/vim-fireplace')
    call dein#add('tpope/vim-scriptease')
    call dein#add('tpope/vim-unimpaired')
    call dein#add('tpope/vim-salve')
    call dein#add('tpope/vim-eunuch')
    call dein#add('tpope/vim-speeddating')
    call dein#add('tpope/vim-cucumber')
    call dein#add('tpope/vim-projectionist')
    call dein#add('tpope/vim-pathogen')
    call dein#add('tpope/vim-obsession')
    call dein#add('tpope/vim-tbone')
    call dein#add('tpope/vim-dadbod')

    call dein#add('lambdalisue/suda.vim')

    " snippets
    call dein#add('honza/vim-snippets')
    call dein#add('Shougo/neosnippet-snippets')
    call dein#add('Shougo/neosnippet.vim')

    " interface
    call dein#add('vim-airline/vim-airline')
    call dein#add('vim-airline/vim-airline-themes')
    call dein#add('flazz/vim-colorschemes')
    call dein#add('rakr/vim-one')
    call dein#add('ryanoasis/vim-devicons')
    call dein#add('mhinz/vim-startify')
    call dein#add('ntpeters/vim-better-whitespace')
    call dein#add('majutsushi/tagbar')
    call dein#add('MattesGroeger/vim-bookmarks')
    call dein#add('wincent/terminus')
    call dein#add('chrisbra/Colorizer')
    call dein#add('junegunn/rainbow_parentheses.vim')

    call dein#add('google/vim-searchindex')
    call dein#add('embear/vim-localvimrc')

    " motion
    call dein#add('easymotion/vim-easymotion')
    call dein#add('rhysd/clever-f.vim')
    " Tools
    call dein#add('editorconfig/editorconfig-vim')
    call dein#add('mattn/emmet-vim')
    call dein#add('mattn/webapi-vim')
    call dein#add('rickhowe/diffchar.vim')
    call dein#add('will133/vim-dirdiff')
    call dein#add('itchyny/calendar.vim')
    call dein#add('diepm/vim-rest-console')
    call dein#add('jsfaint/gen_tags.vim')
    call dein#add('tweekmonster/startuptime.vim')
    call dein#add('justinmk/vim-gtfo')

    call dein#add('google/vimdoc')
    call dein#add('alpertuna/vim-header')
    call dein#add('antoyo/vim-licenses')
    " code format
    call dein#add('sbdchd/neoformat')
    call dein#add('rhysd/vim-clang-format')
    call dein#add('junegunn/vim-easy-align')
    call dein#add('godlygeek/tabular')
    " debug/test
    call dein#add('janko/vim-test')
    call dein#add('thinca/vim-quickrun')

    " VCS
    call dein#add('lambdalisue/gina.vim')
    call dein#add('junegunn/gv.vim')
    call dein#add('gregsexton/gitv')
    call dein#add('mattn/gist-vim')
    call dein#add('idanarye/vim-merginal')
    call dein#add('chrisbra/vim-diff-enhanced')
    call dein#add('rhysd/committia.vim')
    call dein#add('jreybert/vimagit')
    call dein#add('cohama/agit.vim')
    call dein#add('junkblocker/patchreview-vim')
    call dein#add('rhysd/github-complete.vim', {'on_ft': 'gitcommit'})

    " search
    call dein#add('junegunn/fzf', {
                \ 'path': $HOME . '/.fzf',
                \ 'build': './install --key-bindings --no-completion --update-rc',
                \ 'merged': 0
                \ })
    call dein#add('junegunn/fzf.vim')
    call dein#add('haya14busa/incsearch.vim')

    call dein#add('mbbill/undotree')
    call dein#add('haya14busa/dein-command.vim')
    call dein#add('jamessan/vim-gnupg')
    call dein#add('jceb/vim-orgmode')
    call dein#add('vimwiki/vimwiki')

    " comment
    call dein#add('tomtom/tcomment_vim')

    call dein#add('raimondi/delimitmate')
    call dein#add('alvan/vim-closetag')

    call dein#add('sophacles/vim-bundle-mako')
    call dein#add('chrisbra/recover.vim')
    " text object manipulate
    call dein#add('terryma/vim-multiple-cursors')
    call dein#add('michaeljsmith/vim-indent-object')
    call dein#add('kana/vim-textobj-user')
    call dein#add('tommcdo/vim-exchange')
    call dein#add('matze/vim-move')
    call dein#add('christoomey/vim-sort-motion')
    call dein#add('AndrewRadev/switch.vim')
    call dein#add('AndrewRadev/splitjoin.vim')
    call dein#add('AndrewRadev/sideways.vim')
    call dein#add('chrisbra/NrrwRgn')
    call dein#add('machakann/vim-sandwich')
    call dein#add('lfilho/cosco.vim')

    " Languages
    " Go
    call dein#add('fatih/vim-go')
    call dein#add('deoplete-plugins/deoplete-go', {
                \ 'build': 'make',
                \ 'on_ft': 'go',
                \ })
    " c/c++/objc
    call dein#add('octol/vim-cpp-enhanced-highlight')
    " Javascripts...
    call dein#add('othree/yajs.vim')
    call dein#add('othree/javascript-libraries-syntax.vim')
    let g:used_javascript_libs = 'react'
    call dein#add('othree/es.next.syntax.vim', {'on_ft': 'javascript'})
    call dein#add('Quramy/vim-js-pretty-template')
    call dein#add('ternjs/tern_for_vim')
    call dein#add('carlitux/deoplete-ternjs')
    " Typescript
    call dein#add('HerringtonDarkholme/yats.vim')

    call dein#add('mxw/vim-jsx')
    call dein#add('kchmck/vim-coffee-script')
    call dein#add('posva/vim-vue')
    " Haskell
    call dein#add('neovimhaskell/haskell-vim')
    call dein#add('eagletmt/neco-ghc')
    call dein#add('Twinside/vim-hoogle')
    " zsh
    call dein#add('deoplete-plugins/deoplete-zsh')
    " fish
    call dein#add('dag/vim-fish')
    " Html
    call dein#add('othree/html5.vim')
    " vimL
    call dein#add('mhinz/vim-lookup')

    call dein#add('tweekmonster/exception.vim')
    call dein#add('tweekmonster/helpful.vim')
    " Elixir
    call dein#add('slashmili/alchemist.vim')
    call dein#add('elixir-lang/vim-elixir')
    " Java/Kotlin
    call dein#add('artur-shaik/vim-javacomplete2', {'on_ft': 'java'})
    call dein#add('udalov/kotlin-vim')
    " CSS/SCSS/LESS
    "" merged: 0, conflict with othree/html5
    call dein#add('hail2u/vim-css3-syntax', {'merged': 0})
    "" merged: 0, conflict with othree/html5 and many
    call dein#add('ap/vim-css-color', {'merged': 0})
    call dein#add('othree/csscomplete.vim')
    " Python
    call dein#add('davidhalter/jedi-vim', {'on_ft': 'python'})
    call dein#add('deoplete-plugins/deoplete-jedi', {'on_ft': 'python'})
    call dein#add('alfredodeza/pytest.vim')
    " Markdown
    call dein#add('tpope/vim-markdown')
    " glsl
    call dein#add('tikhomirov/vim-glsl')
    " Php
    call dein#add('stanangeloff/php.vim')
    " R
    call dein#add('jalvesaq/Nvim-R')
    " asm
    call dein#add('deoplete-plugins/deoplete-asm')
    " nginx
    call dein#add('chr4/nginx.vim')
    " Rust
    call dein#add('rust-lang/rust.vim')
    call dein#add('racer-rust/vim-racer')
    " Perl/Ruby
    call dein#add('vim-ruby/vim-ruby')
    call dein#add('Shougo/deoplete-rct')
    call dein#add('vim-perl/vim-perl', {
        \ 'rev': 'dev',
        \ 'build': 'make clean carp dancer highlight-all-pragmas moose test-more try-tiny'
        \ })
    call dein#add('vim-perl/vim-perl6')
    " Salt
    call dein#add('saltstack/salt-vim')
    " Erlang
    call dein#add('vim-erlang/vim-erlang-runtime')
    call dein#add('vim-erlang/vim-erlang-omnicomplete')
    " julia
    call dein#add('JuliaEditorSupport/julia-vim')
    " Tmux
    call dein#add('benmills/vimux')
    call dein#add('tmux-plugins/vim-tmux')
    call dein#add('christoomey/vim-tmux-navigator')
    call dein#add('wellle/tmux-complete.vim', {'on_if': 'exists("$TMUX")'})
    " Latex
    call dein#add('lervag/vimtex')
    call dein#add('xuhdev/vim-latex-live-preview', {'on_ft': 'tex'})
    " Json
    call dein#add('elzr/vim-json')
    call dein#add('rodjek/vim-puppet')
    call dein#add('digitaltoad/vim-pug')
    call dein#add('exu/pgsql.vim')
    call dein#add('zah/nim.vim')
    " lua
    call dein#add('tbastos/vim-lua')
    " swift
    call dein#add('keith/swift.vim', {'on_ft': 'swift'})

    call dein#add('jparise/vim-graphql')
    call dein#add('PotatoesMaster/i3-vim-syntax')
    call dein#add('tpope/vim-liquid')
    call dein#add('arrufat/vala.vim')
    call dein#add('cespare/vim-toml')
    call dein#add('solarnz/thrift.vim')
    call dein#add('hashivim/vim-terraform')
    call dein#add('uarun/vim-protobuf')
    call dein#add('lumiliet/vim-twig')
    call dein#add('matt-deacalion/vim-systemd-syntax')
    " YAML playbooks, Jinja2 templates, and Ansible's hosts files.
    call dein#add('pearofducks/ansible-vim')
    call dein#add('stephpy/vim-yaml')
    call dein#add('isobit/vim-caddyfile')
    call dein#add('rhysd/vim-crystal')
    call dein#add('wlangstroth/vim-racket')
    " elm
    call dein#add('elmcast/elm-vim')
    call dein#add('pbogut/deoplete-elm')
    call dein#add('kovisoft/slimv', {'merged': 0})
    " clojure
    call dein#add('guns/vim-clojure-static')
    call dein#add('guns/vim-sexp')
    call dein#add('clojure-vim/async-clj-omni')
    call dein#add('clojure-vim/vim-cider')
    " npm
    call dein#add('rhysd/npm-filetypes.vim')
    " gentoo
    call dein#add('gentoo/gentoo-syntax')
    " blade
    call dein#add('jwalton512/vim-blade')

    call dein#add('dart-lang/dart-vim-plugin')
    call dein#add('derekwyatt/vim-scala', {'on_ft': 'scala'})
    call dein#add('slim-template/vim-slim')
    call dein#add('chrisbra/csv.vim')

    call dein#end()
    call dein#save_state()
endif


" =================== extra conf ============================= "

filetype plugin on
filetype indent on

" global leader
let g:mapleader = ','
" local leader
let g:maplocalleader = '\'

let $LANG='en'
set langmenu=en

" Ignore compiled files
set wildignore=*.o,*~,*.pyc,*.gch
if has('win16') || has('win32')
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

set autoread
set ruler
set cmdheight=2
set scrolloff=3
set hidden
set ignorecase
set smartcase
set hlsearch
set incsearch
set lazyredraw
set magic
set showmatch
set matchtime=2
set history=1000
set wildmenu
set backspace=indent,eol,start

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set timeoutlen=500
set updatetime=500

if has('gui_macvim')
    autocmd GUIEnter * set vb t_vb=
endif

syntax enable

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM ==? 'gnome-terminal'
    set t_Co=256
endif

if has('gui_running')
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

set encoding=utf8

set fileformats=unix,dos,mac

set number
set expandtab
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

set linebreak
set textwidth=500

set autoindent "Auto indent
set smartindent "Smart indent
set wrap "Wrap lines

" terminal mode mapping
function! s:terminal_mapping() abort
    tnoremap <C-w>j <C-\><C-n><C-w>j
    tnoremap <C-w>k <C-\><C-n><C-w>k
    tnoremap <C-w>l <C-\><C-n><C-w>l
    tnoremap <C-w>h <C-\><C-n><C-w>h
endfunction
if has('nvim') || has('terminal')
    call s:terminal_mapping()
endif

" map <silent> <leader><cr> :noh<cr>
nnoremap <leader>tn :tabnew<cr>
nnoremap <leader>to :tabonly<cr>
nnoremap <leader>tc :tabclose<cr>
nnoremap <leader>tm :tabmove<cr>
nnoremap <leader>tl :tabnext<cr>
nnoremap <leader>th :tabprevious<cr>
nnoremap <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" swith to last active tab
let g:lasttab = 1
nnoremap <Leader>ts :exe "tabn ".g:lasttab<CR>
augroup tab_boy
    autocmd!
    autocmd TabLeave * let g:lasttab = tabpagenr()
augroup END

nnoremap <Leader>ec :execute 'edit' g:vimrc<CR>

" Specify the behavior when switching between buffers
try
    set switchbuf=useopen,usetab,newtab
    set showtabline=2
catch
endtry

set laststatus=2

" Cursor shapes, use a blinking upright bar cursor in Insert mode, a blinking block in normal
if &term ==? 'xterm-256color' || &term ==? 'screen-256color'
    " when start insert mode - blinking vertical bar
    let &t_SI = "\<Esc>[5 q"
    " when end insert/replace mode(common) - blinking block
    let &t_EI = "\<Esc>[1 q"
    " when start replace mode
    let &t_SR = "\<Esc>[4 q"
endif

" if exists('$TMUX')
"     let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
"     let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
" endif

set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
		\,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
		\,sm:block-blinkwait175-blinkoff150-blinkon175
augroup cursor_shape
    autocmd!
    autocmd VimLeave * let &t_te .= "\<Esc>[3 q"
    autocmd VimLeave * set guicursor=a:hor25-blinkon300
augroup END

" Make VIM remember position in file after reopen
if has('autocmd')
   au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

if has('mac') || has('macunix')
    set guifont=Hack:h14,Source\ Code\ Pro:h15,Menlo:h15
elseif has('win16') || has('win32')
    set guifont=Hack:h14,Source\ Code\ Pro:h12,Bitstream\ Vera\ Sans\ Mono:h11
elseif has('gui_gtk2')
    set guifont=Hack\ 14,Source\ Code\ Pro\ 12,Bitstream\ Vera\ Sans\ Mono\ 11
elseif has('linux')
    set guifont=Hack\ 14,Source\ Code\ Pro\ 12,Bitstream\ Vera\ Sans\ Mono\ 11
elseif has('unix')
    set guifont=Source\ Code\ Pro\ Medium\ 11
endif

try
    set undodir=$HOME/.vim/temp_dirs/undodir/
    set undofile
catch
endtry

" suda.vim
command! SudaWrite exe 'w suda://%'
command! SudaRead  exe 'e suda://%'

augroup filetype_changes
    autocmd!
    autocmd FileType verilog,verilog_systemverilog setlocal nosmartindent
    autocmd FileType javascript setlocal nocindent
augroup END

autocmd BufRead,BufNewFile *.h setlocal filetype=c
autocmd BufRead,BufNewFile *.verilog,*.vlg setlocal filetype=verilog

" fzf
nnoremap <c-p> :FZF<CR>
let g:fzf_action = {
      \ 'ctrl-a': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }

" fzf-vim
command! Helptags :call fzf#vim#helptags(<bang>0)
command! HelptagsGen :call pathogen#helptags()

" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options
command! -bang -nargs=* Rg call fzf#vim#grep(
      \ 'rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color=always '.shellescape(<q-args>), 1,
      \   <bang>0)
command! -bang -nargs=* Ag
      \ call fzf#vim#ag(<q-args>,
      \                 <bang>0 ? fzf#vim#with_preview('up:60%')
      \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
      \                 <bang>0)
command! -bang -nargs=? -complete=dir Files
      \ call fzf#vim#files(<q-args>, <bang>0)


nmap <Leader><Tab> <plug>(fzf-maps-n)
imap <Leader><Tab> <plug>(fzf-maps-i)
xmap <Leader><Tab> <plug>(fzf-maps-x)
omap <Leader><Tab> <plug>(fzf-maps-o)
if executable('rg')
    set grepprg=rg\ --vimgrep
endif

" tmux navigator
let g:tmux_navigator_no_mappings = 1

" neosnippet
imap <Leader>e <Plug>(neosnippet_expand_or_jump)
smap <Leader>e <Plug>(neosnippet_expand_or_jump)
xmap <Leader>e <Plug>(neosnippet_expand_target)
let g:neosnippet#enable_snipmate_compatibility = 1

" editorconfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://*']

"" see help delimitMateExpansion
let g:delimitMate_expand_cr = 2
let g:delimitMate_expand_space = 1
let g:delimitMate_balance_matchpairs = 1
augroup delimitMateCustom
    autocmd!
    autocmd FileType html,xhtml,xml let b:delimitMate_matchpairs = "(:),[:],{:}"
    autocmd FileType rust let b:delimitMate_quotes = "\" `"
augroup END

" vim-closetag
let g:closetag_filenames = '*.html,*.xhtml,*.xml'
let g:closetag_emptyTags_caseSensitive = 1

" JS-pretty template
augroup JsPreTmpl
    autocmd!
    autocmd FileType javascript JsPreTmpl
    autocmd FileType javascript.jsx JsPreTmpl
    autocmd FileType typescript JsPreTmpl
augroup END

" startify
let g:startify_session_dir = '~/.vim/sessions/'
"let g:startify_list_order = ['files', 'dir', 'bookmarks', 'sessions', 'commands']
let g:startify_update_oldfiles = 1
let g:startify_session_autoload = 1
let g:startify_session_persistence = 1
let g:startify_skiplist = [
      \ '/tmp',
      \ '/usr/share/vim/vimfiles/doc',
      \ '/usr/local/share/vim/vimfiles/doc',
      \ ]
let g:startify_fortune_use_unicode = 1
let g:startify_session_sort = 1
let g:startify_relative_path = 1

" vim-gitgutter
let g:gitgutter_max_signs = 1000

" Ale
let g:ale_linters = {
            \ 'rust': ['cargo', 'rls', 'rustc'],
            \ 'python': ['flake8', 'mypy', 'pylint', 'pyls', 'autopep8', 'black', 'isort', 'yapf', 'pyre', 'bandit'],
            \ }
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
if $TERM =~# 'linux'
    let g:ale_sign_error = '>>'
    let g:ale_sign_warning = '--'
    let g:ale_sign_info = '!'
else
    let g:ale_sign_error = '✖'
    let g:ale_sign_warning = '⚠'
    let g:ale_sign_info = 'ℹ'
endif
nmap <silent> <c-k> <Plug>(ale_previous_wrap)
nmap <silent> <c-j> <Plug>(ale_next_wrap)
augroup ALE_LPS
    autocmd!
    autocmd FileType c,cpp nnoremap <c-]> <Plug>(ale_go_to_definition)
augroup END

" vim-racer
let g:racer_experimental_completer = 1
augroup RACER_RUST
    autocmd!
    autocmd FileType rust command! RustDef call racer#GoToDefinition()
    autocmd FileType rust command! RustDoc call racer#ShowDocumentation()
    autocmd FileType rust nmap <c-]> <Plug>(rust-def)
    autocmd FileType rust nmap <c-w>] <Plug>(rust-def-split)
augroup END

" vim-go
augroup VIM_GO
    autocmd!
    autocmd FileType go nnoremap <c-]> :GoDef<CR>
    autocmd FileType go call LanguageClient#startServer()
augroup END
" deoplete-go
let g:deoplete#sources#go#pointer = 1
let g:deoplete#sources#go#builtin_objects = 1
let g:deoplete#sources#go#unimported_packages = 1

if has('nvim')
    augroup VIM_TYPESCRIPT
        autocmd!
        autocmd FileType typescript,typescript.tsx nnoremap <c-]> :TSDef<CR>
    augroup END
endif

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline_theme='onedark'

set background=dark

if $TERM=~#'xterm-256color' || $TERM=~#'screen-256color' || $TERM=~#'xterm-color' || has('gui_running')
    "Credit joshdick
    "Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
    "If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
    "(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
    " if empty($TMUX)
        if has('nvim')
            "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
            let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
        endif
        "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
        "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
        "< https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
        if has('termguicolors')
            set termguicolors
        endif
    " endif
    colorscheme one

    " enable powerline on those environments
    let g:airline_powerline_fonts = 1
    let g:powerline_pycmd = 'py3'
    let g:airline_theme = 'onedark'
endif

highlight SpellBad ctermfg=050 ctermbg=088 guifg=#00ffd7 guibg=#870000

let g:markdown_composer_open_browser = 0

" vim-markdown
let g:markdown_fenced_languages = ['html', 'json', 'javascript', 'c', 'bash=sh']

" incsearch.vim
if !has('patch-8.0-1241')
    map / <Plug>(incsearch-forward)
    map ? <Plug>(incsearch-backward)
    map g/ <Plug>(incsearch-stay)
endif

" vim-wiki
let g:vimwiki_table_mappings = 0

" easy-align
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" defx
augroup Defx
    " uncomment this to use defx as default explorer
    " see https://github.com/justinmk/vim-dirvish/blob/4ae4303748221543aaa37030f209da11de817270/plugin/dirvish.vim#L8-L20
    " autocmd VimEnter * silent! au! FileExplorer *
    " autocmd BufEnter * if <SID>is_dir(expand('%')) | redraw | echo '' | exe 'Defx' | endif
    autocmd FileType defx call s:defx_settings()
augroup end
command! DefxTab :Defx -split=vertical -winwidth=50 -direction=topleft
command! DefxCwd :Defx `expand('%:p:h')` -search=`expand('%:p')`
function! s:defx_settings() abort
    " Define mappings
    nnoremap <silent><buffer><expr> <CR>
                \ defx#do_action('open')
    nnoremap <silent><buffer><expr> C
                \ defx#do_action('copy')
    nnoremap <silent><buffer><expr> m
                \ defx#do_action('move')
    nnoremap <silent><buffer><expr> p
                \ defx#do_action('paste')
    nnoremap <silent><buffer><expr> l
                \ defx#do_action('open')
    nnoremap <silent><buffer><expr> h
                \ defx#do_action('cd', ['..'])
    nnoremap <silent><buffer><expr> S
                \ defx#do_action('open', 'split')
    nnoremap <silent><buffer><expr> E
                \ defx#do_action('open', 'vsplit')
    nnoremap <silent><buffer><expr> P
                \ defx#do_action('open', 'pedit')
    nnoremap <silent><buffer><expr> o
                \ defx#do_action('open_or_close_tree')
    nnoremap <silent><buffer><expr> K
                \ defx#do_action('new_directory')
    nnoremap <silent><buffer><expr> N
                \ defx#do_action('new_file')
    nnoremap <silent><buffer><expr> M
                \ defx#do_action('new_multiple_files')
    nnoremap <silent><buffer><expr> c
                \ defx#do_action('toggle_columns',
                \                'mark:indent:icon:icons:filename:type:size:time')
    nnoremap <silent><buffer><expr> x
                \ defx#do_action('toggle_columns',
                \                'mark:indent:icon:filename:size:time')
    nnoremap <silent><buffer><expr> s
                \ defx#do_action('toggle_sort', 'time')
    nnoremap <silent><buffer><expr> dd
                \ defx#do_action('remove')
    nnoremap <silent><buffer><expr> r
                \ defx#do_action('rename')
    nnoremap <silent><buffer><expr> !
                \ defx#do_action('execute_command')
    nnoremap <silent><buffer><expr> X
                \ defx#do_action('execute_system')
    nnoremap <silent><buffer><expr> yy
                \ defx#do_action('yank_path')
    nnoremap <silent><buffer><expr> .
                \ defx#do_action('toggle_ignored_files')
    nnoremap <silent><buffer><expr> ;
                \ defx#do_action('repeat')
    nnoremap <silent><buffer><expr> ~
                \ defx#do_action('cd')
    nnoremap <silent><buffer><expr> q
                \ defx#do_action('quit')
    nnoremap <silent><buffer><expr> <Space>
                \ defx#do_action('toggle_select') . 'j'
    nnoremap <silent><buffer><expr> *
                \ defx#do_action('toggle_select_all')
    nnoremap <silent><buffer><expr> j
                \ line('.') == line('$') ? 'gg' : 'j'
    nnoremap <silent><buffer><expr> k
                \ line('.') == 1 ? 'G' : 'k'
    nnoremap <silent><buffer><expr> <C-l>
                \ defx#do_action('redraw')
    nnoremap <silent><buffer><expr> <C-g>
                \ defx#do_action('print')
    nnoremap <silent><buffer><expr> cd
                \ defx#do_action('change_vim_cwd')
endfunction

function! s:is_dir(path) abort
    return !empty(a:path) && (isdirectory(a:path) ||
                \ (!empty($SYSTEMDRIVE) && isdirectory('/'.tolower($SYSTEMDRIVE[0]).a:path)))
endfunction


set completeopt-=preview
" echodoc
let g:echodoc#enable_at_startup = 1

" deoplete
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option({
            \ 'auto_complete': v:true,
            \ 'ignore_case': v:true,
            \ 'smart_case': v:true,
            \ })
if !has('nvim')
    call deoplete#custom#option('yarp', v:true)
endif

" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> pumvisible() ? deoplete#smart_close_popup()."\<C-h>" :
            \ delimitMate#BS()
inoremap <expr><C-g> deoplete#undo_completion()
" <CR>: close popup and save indent.
" inoremap <expr><CR> pumvisible() ? deoplete#close_popup()."\<CR>"
"                 \ : "<Plug>delimiteMate"

" Tab complete
inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ deoplete#manual_complete()
inoremap <silent><expr> <S-TAB>
            \ pumvisible() ? "\<C-p>" :
            \ "\<S-TAB>"
function! s:check_back_space() abort "{{{
    let l:col = col('.') - 1
    return !l:col || getline('.')[l:col - 1]  =~ '\s'
endfunction "}}}

call deoplete#custom#source('omni', 'input_patterns', {
            \ 'ruby': ['[^. *\t]\.\w*', '[a-zA-Z_]\w*::'],
            \ 'java': '[^. *\t]\.\w*',
            \ 'php': '\w+|[^. \t]->\w*|\w+::\w*',
            \ 'javascript': '[^. *\t]\.\w*',
            \ 'typescript': '[^. *\t]\.\w*|\h\w*:',
            \ 'css': '[^. *\t]\.\w*',
            \ })

call deoplete#custom#source('omni', 'function',{
            \ 'typescript': [ 'LanguageClient#complete', 'tsuquyomi#complete' ],
            \ 'c': [ 'LanguageClient#complete', 'ale#completion#OmniFunc' ],
            \ 'cpp': [ 'LanguageClient#complete', 'ale#completion#OmniFunc' ],
            \ 'rust': [ 'racer#RacerComplete', 'LanguageClient#complete'],
            \ 'php': [ 'phpactor#Complete', 'LanguageClient#complete' ],
            \ })

" call deoplete#custom#option('keyword_patterns', {
"             \ 'clojure': '[\w!$%&*+/:<=>?@\^_~\-\.#]*'
"             \ })
" source rank
call deoplete#custom#source('look', {
            \ 'rank': 40,
            \ 'max_candidates': 15,
            \ })

" deoplete-ternjs
let g:deoplete#sources#ternjs#types = 1
let g:deoplete#sources#ternjs#depths = 1
let g:deoplete#sources#ternjs#docs = 1
let g:deoplete#sources#ternjs#filter = 0
let g:deoplete#sources#ternjs#case_insensitive = 1
let g:deoplete#sources#ternjs#guess = 0
let g:deoplete#sources#ternjs#omit_object_prototype = 0
let g:deoplete#sources#ternjs#include_keywords = 1
let g:deoplete#sources#ternjs#in_literal = 0
let g:deoplete#sources#ternjs#filetypes = [
                \ 'jsx',
                \ 'vue',
                \ '...'
                \ ]

" tern_for_vim
let g:tern#command = ['tern']
let g:tern#arguments = ['--persistent']

" Enable omni completion.
augroup omni_complete
    autocmd!
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    " Tern for vim
    autocmd FileType javascript setlocal omnifunc=tern#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    " Java complete2
    autocmd FileType java setlocal omnifunc=javacomplete#Complete
    " neco-ghc
    autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
    " jedi
    autocmd FileType python setlocal omnifunc=jedi#completions
    autocmd FileType php setlocal omnifunc=phpactor#Complete
augroup END

" jedi
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#smart_auto_mappings = 1
let g:jedi#use_tabs_not_buffers = 1
let g:jedi#use_splits_not_buffers = 'winwidth'
let g:jedi#completions_command = ''
let g:jedi#usages_command = '<Leader>nn'
let g:jedi#rename_command = '<Leader>r'
let g:jedi#documentation_command = 'K'
let g:jedi#goto_command = '<C-]>'
let g:jedi#goto_assignments_command = '<Leader>ga'
let g:jedi#goto_definitions_command = ''

let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'

" lua
let g:lua_check_syntax = 0
let g:lua_complete_omni = 1
let g:lua_complete_dynamic = 0
let g:lua_define_completion_mappings = 0

" neoinclude
if !exists('g:neoinclude#exts')
let g:neoinclude#exts = {}
endif
let g:neoinclude#exts.c = ['', 'h']
let g:neoinclude#exts.cpp = ['', 'h', 'hpp', 'hxx']

if !exists('g:neoinclude#paths')
let g:neoinclude#paths = {}
endif

let g:neoinclude#paths.c = '.,'
        \ . '/usr/lib/gcc/*/*/include/,'
        \ . '/usr/local/include/,'
        \ . '/usr/lib/gcc/*/*/include-fixed/,'
        \ . '/usr/include/,,'

let g:neoinclude#paths.cpp = '.,'
        \ . '/usr/include/c++/*/,'
        \ . '/usr/include/c++/*/*/,'
        \ . '/usr/include/c++/*/backward/,'
        \ . '/usr/local/include/,'
        \ . '/usr/lib/gcc/*/*/include/,'
        \ . '/usr/lib/gcc/*/*/include-fixed/,'
        \ . '/usr/lib/gcc/*/*/include/g++-v*/,'
        \ . '/usr/lib/gcc/*/*/include/g++-v*/backward,'
        \ . '/usr/lib/gcc/*/*/include/g++-v*/*/,'
        \ . '/usr/include/,,'


" vim-sort-motion
let g:sort_motion = '<Leader>sm'
let g:sort_motion_lines = '<Leader>sml'
let g:sort_motion_visual = '<Leader>sm'

" tcomment
let g:tcomment_maps = 0

inoremap <C-Space> <C-x><c-o>
if !has('gui_running')
    inoremap <C-@> <C-x><C-o>
endif

" vim-header
let g:header_auto_add_header = 0

" vim-bookmarks
let g:bookmark_no_default_key_mappings = 1

" vim-cpp-enhanced-highlight
" let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_concepts_highlight = 1

" rainbow
augroup rainbow_lisp
  autocmd!
  autocmd FileType lisp,clojure,scheme RainbowParentheses
augroup END

" quickrun
let g:quickrun_no_default_key_mappings = 1

" tmux-complete
let g:tmuxcomplete#trigger = ''

" vim-pandoc
let g:pandoc#filetypes#pandoc_markdown = 0

" elm-vim
let g:elm_setup_keybindings = 0

" vim-online-thesaurus*
let g:online_thesaurus_map_keys = 0

" gen_tags
if !executable('gtags')
    let g:loaded_gentags#gtags = 1
endif

" vim-lookup
augroup gp_lookup
    autocmd!
    autocmd FileType vim nnoremap <buffer><silent> <C-]> :call lookup#lookup()<CR>
augroup END

" gina
let g:gina#command#blame#formatter#format = '%su%=by %au on %ti, %ma/%in'

let g:livepreview_engine = 'xelatex'

" localvimrc
let g:localvimrc_name = [ '.lc.vim' ]

let g:better_whitespace_operator = ''
