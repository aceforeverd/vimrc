if &compatible
    set nocompatible
endif

set runtimepath+=$HOME/.vim/dein/repos/github.com/Shougo/dein.vim

let g:dein#install_process_timeout = 180
let g:dein#install_process_type = 'tabline'
if dein#load_state($HOME . '/.vim/dein')
    call dein#begin($HOME . '/.vim/dein')

    call dein#add($HOME . '/.vim/dein/repos/github.com/Shougo/dein.vim')

    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')

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
    call dein#add('Shougo/vimfiler.vim')
    call dein#add('Shougo/neco-vim')
    call dein#add('Shougo/neoyank.vim')
    call dein#add('Shougo/echodoc.vim')
    call dein#add('Shougo/neossh.vim')
    call dein#add('Shougo/deol.nvim')
    call dein#add('ujihisa/neco-look')

    " tpope
    call dein#add('tpope/vim-endwise')
    call dein#add('tpope/vim-commentary')
    call dein#add('tpope/vim-surround')
    call dein#add('tpope/vim-ragtag')
    call dein#add('tpope/vim-dispatch')
    call dein#add('tpope/vim-rhubarb')
    call dein#add('tpope/tpope-vim-abolish')
    call dein#add('tpope/vim-repeat')
    call dein#add('tpope/vim-haml')
    call dein#add('tpope/vim-bundler')
    call dein#add('tpope/vim-rails')
    call dein#add('tpope/vim-rake')
    call dein#add('tpope/vim-fireplace')
    call dein#add('tpope/vim-scriptease')
    call dein#add('tpope/vim-unimpaired')
    call dein#add('tpope/vim-salve')
    call dein#add('tpope/vim-eunuch')
    call dein#add('tpope/vim-speeddating')
    call dein#add('tpope/vim-cucumber')
    call dein#add('tpope/vim-projectionist')
    call dein#add('tpope/vim-pathogen')
    call dein#add('tpope/vim-heroku')

    " snippets
    call dein#add('honza/vim-snippets')
    call dein#add('sirver/ultisnips')
    call dein#add('Shougo/neosnippet-snippets')
    call dein#add('Shougo/neosnippet.vim')

    " interface
    call dein#add('vim-airline/vim-airline')
    call dein#add('vim-airline/vim-airline-themes')
    call dein#add('flazz/vim-colorschemes')
    call dein#add('rakr/vim-one')
    call dein#add('ryanoasis/vim-devicons')
    call dein#add('mhinz/vim-startify')
    call dein#add('junegunn/vim-journal')
    call dein#add('ntpeters/vim-better-whitespace')
    call dein#add('majutsushi/tagbar')
    call dein#add('kshenoy/vim-signature')
    call dein#add('MattesGroeger/vim-bookmarks')
    call dein#add('wincent/terminus')
    call dein#add('chrisbra/Colorizer')
    call dein#add('junegunn/rainbow_parentheses.vim')

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
    call dein#add('vimoutliner/vimoutliner')
    call dein#add('vim-utils/vim-man')
    call dein#add('jsfaint/gen_tags.vim')
    call dein#add('tweekmonster/startuptime.vim', {'on_cmd': 'StartupTime'})
    call dein#add('mhinz/vim-sayonara', {'on_cmd': 'Sayonara'})

    call dein#add('google/vimdoc')
    call dein#add('alpertuna/vim-header')
    call dein#add('antoyo/vim-licenses')
    " code format
    call dein#add('sbdchd/neoformat')
    call dein#add('rhysd/vim-clang-format')
    call dein#add('junegunn/vim-easy-align')
    call dein#add('godlygeek/tabular')
    " debug/test
    call dein#add('w0rp/ale')
    call dein#add('janko-m/vim-test')
    call dein#add('idanarye/vim-vebugger')
    call dein#add('thinca/vim-quickrun')

    " VCS
    call dein#add('tpope/vim-fugitive')
    call dein#add('lambdalisue/gina.vim')
    call dein#add('junegunn/gv.vim')
    call dein#add('gregsexton/gitv')
    call dein#add('mattn/gist-vim')
    call dein#add('airblade/vim-gitgutter')
    call dein#add('idanarye/vim-merginal')
    call dein#add('chrisbra/vim-diff-enhanced')
    call dein#add('rhysd/committia.vim')
    call dein#add('jreybert/vimagit')
    call dein#add('cohama/agit.vim')
    call dein#add('junkblocker/patchreview-vim')
    call dein#add('rhysd/github-complete.vim')

    " search
    call dein#add('junegunn/fzf', {
                \ 'path': $HOME . '/.fzf',
                \ 'build': './install --key-bindings --no-completion --update-rc',
                \ 'merged': 0
                \ })
    call dein#add('junegunn/fzf.vim')
    call dein#add('haya14busa/incsearch.vim')
    call dein#add('dyng/ctrlsf.vim')

    call dein#add('mbbill/undotree')
    call dein#add('haya14busa/dein-command.vim')
    call dein#add('jamessan/vim-gnupg')
    call dein#add('jceb/vim-orgmode')
    call dein#add('vimwiki/vimwiki')
    call dein#add('thaerkh/vim-workspace')

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
    call dein#add('zchee/deoplete-go', {
                \ 'build': 'make',
                \ 'on_ft': 'go',
                \ })
    " c/c++/objc
    call dein#add('octol/vim-cpp-enhanced-highlight')
    call dein#add('aceforeverd/clang_complete')
    " Javascripts...
    call dein#add('pangloss/vim-javascript')
    call dein#add('othree/javascript-libraries-syntax.vim')
    call dein#add('Quramy/vim-js-pretty-template')
    call dein#add('marijnh/tern_for_vim')
    call dein#add('carlitux/deoplete-ternjs')
    " Typescript
    call dein#add('mhartington/nvim-typescript', {'on_ft': 'typescript'})
    call dein#add('HerringtonDarkholme/yats.vim')

    call dein#add('mxw/vim-jsx')
    call dein#add('kchmck/vim-coffee-script')
    call dein#add('posva/vim-vue')
    " Haskell
    call dein#add('neovimhaskell/haskell-vim')
    call dein#add('eagletmt/neco-ghc')
    call dein#add('Twinside/vim-hoogle')
    " zsh
    call dein#add('zchee/deoplete-zsh')
    " fish
    call dein#add('dag/vim-fish')
    " Html
    call dein#add('othree/html5.vim')
    " vimL
    call dein#add('mhinz/vim-lookup')
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
    call dein#add('zchee/deoplete-jedi', {'on_ft': 'python'})
    call dein#add('alfredodeza/pytest.vim')
    call dein#add('vimjas/vim-python-pep8-indent')
    " Markdown
    call dein#add('tyru/open-browser.vim')
    call dein#add('tpope/vim-markdown')
    " glsl
    call dein#add('tikhomirov/vim-glsl')
    " Php
    call dein#add('stanangeloff/php.vim')
    call dein#add('lvht/phpcd.vim', {
                \ 'build': 'composer install',
                \ 'on_ft': 'php',
                \ })
    " R
    call dein#add('jalvesaq/Nvim-R')
    " asm
    call dein#add('zchee/deoplete-asm')
    " Rust
    call dein#add('rust-lang/rust.vim', {'on_ft': 'rust'})
    call dein#add('racer-rust/vim-racer')
    call dein#add('sebastianmarkow/deoplete-rust', {'on_ft': 'rust'})
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
    call dein#add('xuhdev/vim-latex-live-preview')
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
    call dein#add('ekalinin/dockerfile.vim')
    call dein#add('matt-deacalion/vim-systemd-syntax')
    " YAML playbooks, Jinja2 templates, and Ansible's hosts files.
    call dein#add('pearofducks/ansible-vim')
    call dein#add('stephpy/vim-yaml')
    call dein#add('isobit/vim-caddyfile')
    call dein#add('rhysd/vim-crystal')
    call dein#add('wlangstroth/vim-racket')
    " elm
    call dein#add('elmcast/elm-vim')
    call dein#add('kovisoft/slimv', {'merged': 0})
    " clojure
    call dein#add('guns/vim-clojure-static')
    call dein#add('guns/vim-sexp')
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

    call dein#add('rhysd/vim-grammarous', {'merged': 0})

    call dein#end()
    call dein#save_state()
endif


" pathogen
" add plugins in ~/.vim/bundle
" execute pathogen#infect('~/.vim/bundle/{}')

" vim plug
" ============================================================================================
call plug#begin('~/.vim/vimPlug')

Plug 'autozimu/LanguageClient-neovim'
Plug 'natebosch/vim-lsc'
let g:lsc_auto_map = v:false
let g:lsc_server_commands = {}
" let g:lsc_server_commands.typescript = 'javascript-typescript-stdio'
" let g:lsc_server_commands.javascript = 'javascript-typescript-stdio'
" let g:lsc_server_commands.c = 'clangd'
" let g:lsc_server_commands.rust = 'rls'
" let g:lsc_server_commands.dart = 'dart_language_server'

" Plug 'prabirshrestha/async.vim'
" Plug 'prabirshrestha/vim-lsp'
" if executable('docker-langserver')
"     autocmd User lsp_setup call lsp#register_server({
"                 \ 'name': 'docker-langserver',
"                 \ 'cmd': {server_info->[&shell, &shellcmdflag, 'docker-langserver --stdio']},
"                 \ 'whitelist': ['dockerfile', 'Dockerfile'],
"                 \ })
"     autocmd FileType Dockerfile setlocal omnifunc=lsp#complete
" endif

Plug 'sjl/splice.vim'
Plug 'junegunn/vader.vim'
Plug 'Quramy/tsuquyomi', {'for': 'typescript'}
Plug 'google/vim-searchindex'
Plug 'roxma/LanguageServer-php-neovim', {
            \ 'do': 'composer install && composer run-script parse-stubs',
            \ 'for': 'php',
            \ }
Plug 'phpactor/phpactor', {
            \ 'do': 'composer install',
            \ 'for': 'php',
            \ 'dir': $HOME . '/.phpactor',
            \ }
Plug 'vim-pandoc/vim-pandoc'
Plug 'andreshazard/vim-logreview'
Plug 'mzlogin/vim-markdown-toc', {'for': 'markdown'}
Plug 'beloglazov/vim-online-thesaurus', {'on': 'OnlineThesaurusCurrentWord'}
" Plug 'vhda/verilog_systemverilog.vim'

function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    if has('nvim')
      !cargo build --release
    else
      !cargo build --release --no-default-features --features json-rpc
    endif
  endif
endfunction

Plug 'euclio/vim-markdown-composer', {
            \ 'do': function('BuildComposer'),
            \ 'for': 'markdown',
            \ }
Plug 'xolox/vim-misc', {'for': 'lua'}
Plug 'xolox/vim-lua-ftplugin', {'for': 'lua'}
Plug 'c9s/perlomni.vim', {'for': 'perl'}

call plug#end()

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
if $COLORTERM == 'gnome-terminal'
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
autocmd TabLeave * let g:lasttab = tabpagenr()

" Specify the behavior when switching between buffers
try
    set switchbuf=useopen,usetab,newtab
    set showtabline=2
catch
endtry

set laststatus=2

" Cursor shapes, use a blinking upright bar cursor in Insert mode, a blinking block in normal
if &term == 'xterm-256color' || &term == 'screen-256color'
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
    set guifont=Source\ Code\ Pro\ Medium\ 12
endif

try
    set undodir=~/.vim/temp_dirs/undodir/
    set undofile
catch
endtry

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

" Utilsnips
let g:UltiSnipsExpandTrigger = '<leader>x'
let g:UltiSnipsListSnippets = '<Leader>l'
let g:UltiSnipsJumpForwardTrigger = '<c-j>'
let g:UltiSnipsJumpBackwardTrigger = '<c-k>'
let g:UltiSnipsEditSplit = 'vertical'

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

" vim-closetag
let g:closetag_filenames = '*.html,*.xhtml,*.xml'
let g:closetag_emptyTags_caseSensitive = 1

" javascript-libraries-syntax
let g:used_javascript_libs = 'jquery,angularjs,angularui,angularuirouter'

" JS-pretty template
augroup JsPreTmpl
    autocmd!
    autocmd FileType javascript JsPreTmpl html
    autocmd FileType typescript JsPreTmpl markdown
augroup END

" vim-javascript
let g:javascript_plugin_jsdoc = 1

" startify
let g:startify_session_dir = '~/.vim/sessions/'
"let g:startify_list_order = ['files', 'dir', 'bookmarks', 'sessions', 'commands']
let g:startify_update_oldfiles = 1
let g:startify_session_autoload = 1
let g:startify_session_persistence = 1
let g:startify_skiplist = [
      \ '/tmp',
      \ '/usr/share/vim/vim80/doc',
      \ '/usr/share/vim/vimfiles/doc',
      \ '/usr/local/share/vim/vim80/doc',
      \ '/usr/local/share/vim/vimfiles/doc',
      \ $HOME . '/.vim/dein/.cache/.vimrc/.dein/doc'
      \ ]
let g:startify_fortune_use_unicode = 1
let g:startify_session_sort = 1
let g:startify_relative_path = 1

" vim-gitgutter
let g:gitgutter_max_signs = 1000

" Ale
let g:ale_linters = {
            \ }
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_sign_error = '✖'
let g:ale_sign_warning = '⚠'
let g:ale_sign_info = 'ℹ'
nmap <silent> <c-k> <Plug>(ale_previous_wrap)
nmap <silent> <c-j> <Plug>(ale_next_wrap)

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline_theme='onedark'

let g:markdown_composer_open_browser = 0

" vim-markdown
let g:markdown_fenced_languages = ['html', 'json', 'javascript', 'c', 'bash=sh']

" vim-signature
let g:SignatureMap = {
        \ 'Leader'             :  '<Leader>m',
        \ 'PlaceNextMark'      :  '<Leader>m,',
        \ 'ToggleMarkAtLine'   :  '<Leader>m.',
        \ 'PurgeMarksAtLine'   :  '<Leader>m-',
        \ 'DeleteMark'         :  'dm',
        \ 'PurgeMarks'         :  '<Leader>m<Space>',
        \ 'PurgeMarkers'       :  '<Leader>m<BS>',
        \ 'GotoNextLineAlpha'  :  '',
        \ 'GotoPrevLineAlpha'  :  '',
        \ 'GotoNextSpotAlpha'  :  '',
        \ 'GotoPrevSpotAlpha'  :  '',
        \ 'GotoNextLineByPos'  :  '',
        \ 'GotoPrevLineByPos'  :  '',
        \ 'GotoNextSpotByPos'  :  '',
        \ 'GotoPrevSpotByPos'  :  '',
        \ 'GotoNextMarker'     :  '',
        \ 'GotoPrevMarker'     :  '',
        \ 'GotoNextMarkerAny'  :  '',
        \ 'GotoPrevMarkerAny'  :  '',
        \ 'ListBufferMarks'    :  '',
        \ 'ListBufferMarkers'  :  ''
        \ }

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

" LanguageClient
augroup GP_LanguageClient
    autocmd!
    " autocmd FileType typescript LanguageClientStart
augroup end
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ 'typescript': ['javascript-typescript-stdio'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'go': ['go-langserver'],
    \ 'yaml': ['/usr/bin/node', $HOME . '/Git/yaml-language-server/out/server/src/server.js', '--stdio'],
    \ 'css': ['css-language-server', '--stdio'],
    \ 'sass': ['css-language-server', '--stdio'],
    \ 'less': ['css-language-server', '--stdio'],
    \ 'dockerfile': ['docker-langserver', '--stdio'],
    \ 'Dockerfile': ['docker-langserver', '--stdio'],
    \ 'reason': ['ocaml-language-server', '--stdio'],
    \ 'ocaml': ['ocaml-language-server', '--stdio'],
    \ 'vue': ['vls'],
    \ 'lua': ['lua-lsp'],
    \ 'ruby': ['language_server-ruby'],
    \ 'c': ['clangd'],
    \ 'cpp': ['cland'],
    \ 'python': ['pyls'],
    \ }
nnoremap <silent> gK :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>


" vimfiler
call vimfiler#set_execute_file('vim', ['vim', 'nvim'])

let g:vimfiler_as_default_explorer = 1
let g:vimfiler_ignore_pattern = ['^\.', '\.o$']
let g:vimfiler_tree_opened_icon = '▾'
let g:vimfiler_tree_closed_icon = '▸'
let g:vimfiler_marked_file_icon = '*'

call vimfiler#custom#profile('default', 'context', {
            \ 'safe' : 0,
            \ 'edit_action' : 'tabopen',
            \ })


set completeopt-=preview
" echodoc
let g:echodoc#enable_at_startup = 1

" deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_yarp = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#auto_complete_start_length = 2

" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> pumvisible() ? deoplete#smart_close_popup()."\<C-h>" :
            \ delimitMate#BS()

" Tab complete
inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ deoplete#mappings#manual_complete()
inoremap <expr> <S-TAB>
            \ pumvisible() ? "\<C-p>" :
            \ "\<S-TAB>"
function! s:check_back_space() abort "{{{
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction "}}}

if !exists('g:deoplete#omni#input_patterns')
    let g:deoplete#omni#input_patterns = {}
endif
let g:deoplete#omni#input_patterns.ruby = ['[^. *\t]\.\w*', '[a-zA-Z_]\w*::']
let g:deoplete#omni#input_patterns.java = '[^. *\t]\.\w*'
let g:deoplete#omni#input_patterns.javascript = '[^. *\t]\.\w*'
let g:deoplete#omni#input_patterns.typescript = '[^. *\t]\.\w*|\h\w*:'

if !exists('g:deoplete#omni_patterns')
    let g:deoplete#omni_patterns = {}
endif
let g:deoplete#omni_patterns.php = '\w+|[^. \t]->\w*|\w+::\w*'

if !exists('g:deoplete#omni#functions')
	let g:deoplete#omni#functions = {}
endif
let g:deoplete#omni#functions.php = [ 'phpcd#CompletePHP' ]
let g:deoplete#omni#functions.typescript = [ 'tsuquyomi#complete' ]

if !exists('g:deoplete#ignore_sources')
    let g:deoplete#ignore_sources = {}
endif

if !exists('g:deoplete#keyword_patterns')
    let g:deoplete#keyword_patterns = {}
endif
let g:deoplete#keyword_patterns.clojure = '[\w!$%&*+/:<=>?@\^_~\-\.#]*'

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


" neocomplete

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
endif

if !exists('g:neocomplete#sources#omni#functions')
    let g:neocomplete#sources#omni#functions = {}
endif

"" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.php =
            \ '\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
let g:neocomplete#sources#omni#input_patterns.c =
            \ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?'
let g:neocomplete#sources#omni#input_patterns.cpp =
            \ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
let g:neocomplete#sources#omni#input_patterns.go = '[^.[:digit:] *\t]\.\w*'
let g:neocomplete#sources#omni#input_patterns.java = '\h\w*\.\w*'

" perlomni
let g:neocomplete#sources#omni#input_patterns.perl =
	\ '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'


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
augroup END

" clang_complete
let g:clang_complete_macros = 1
let g:clang_complete_patterns = 1

" jedi
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#smart_auto_mappings = 0
let g:jedi#use_tabs_not_buffers = 1
let g:jedi#use_splits_not_buffers = 'winwidth'
let g:jedi#usages_command = '<Leader>nn'

let g:neocomplete#force_omni_input_patterns.python =
            \ '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'

let g:neocomplete#force_omni_input_patterns.typescript = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplete#force_omni_input_patterns.javascript = '[^. \t]\.\w*'
let g:neocomplete#force_omni_input_patterns.erlang = '\<[[:digit:][:alnum:]_-]\+:[[:digit:][:alnum:]_-]*'
let g:neocomplete#force_omni_input_patterns.objcpp =
            \ '\[\h\w*\s\h\?\|\h\w*\%(\.\|->\)\|\h\w*::\w*'
" lua
let g:lua_check_syntax = 0
let g:lua_complete_omni = 1
let g:lua_complete_dynamic = 0
let g:lua_define_completion_mappings = 0
let g:neocomplete#sources#omni#functions.lua =
	      \ 'xolox#lua#omnifunc'
let g:neocomplete#sources#omni#input_patterns.lua =
	      \ '\w\+[.:]\|require\s*(\?["'']\w*'


if !exists('g:neocomplete#delimiter_patterns')
    let g:neocomplete#delimiter_patterns= {}
endif
let g:neocomplete#delimiter_patterns.vim = ['#']
let g:neocomplete#delimiter_patterns.cpp = ['::']

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
            \ . '/usr/lib/gcc/x86_64-pc-linux-gnu/*/include/,'
            \ . '/usr/local/include/,'
            \ . '/usr/lib/gcc/x86_64-pc-linux-gnu/*/include-fixed/,'
            \ . '/usr/include/,,'

let g:neoinclude#paths.cpp = '.,'
            \ . '/usr/include/c++/*/,'
            \ . '/usr/include/c++/*/x86_64-pc-linux-gnu/,'
            \ . '/usr/include/c++/*/backward/,'
            \ . '/usr/lib/gcc/x86_64-pc-linux-gnu/*/include/,'
            \ . '/usr/local/include/,'
            \ . '/usr/lib/gcc/x86_64-pc-linux-gnu/*/include-fixed/,'
            \ . '/usr/lib/gcc/x86_64-pc-linux-gnu/*/include/g++-v6/,'
            \ . '/usr/lib/gcc/x86_64-pc-linux-gnu/*/include/g++-v6/backward,'
            \ . '/usr/lib/gcc/x86_64-pc-linux-gnu/*/include/g++-v6/x86_64-pc-linux-gnu/,'
            \ . '/usr/include/,,'


if $TERM=~'linux'
    colorscheme torte
elseif $TERM=~'xterm-256color' || has('gui_running')
    let g:NERDTreeFileExtensionHighlightFullName = 1
    let g:NERDTreeExactMatchHighlightFullName = 1
    let g:NERDTreePatternMatchHighlightFullName = 1

    let g:airline_powerline_fonts = 1

    let g:airline_theme = 'onedark'

    colorscheme one

    set termguicolors
    set background=dark

endif

if !empty($TMUX)
    set term=screen-256color
    set notermguicolors
    colorscheme onedark
    let g:airline_powerline_fonts = 1
endif

highlight SpellBad ctermfg=050 ctermbg=088 guifg=#00ffd7 guibg=#870000

" vim-sort-motion
let g:sort_motion = '<Leader>sm'
let g:sort_motion_lines = '<Leader>sml'
let g:sort_motion_visual = '<Leader>sm'

let g:workspace_autosave_ignore = ['gitcommit']

" tcomment
let g:tcommentMaps = 0

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

" vim-go
let g:go_template_autocreate = 0

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
