set runtimepath+=~/.vim/dein.vim/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('~/.vim/dein.vim')
    call dein#begin('~/.vim/dein.vim')

    call dein#add('~/.vim/dein.vim/repos/github.com/Shougo/dein.vim')

    call dein#add('Shougo/neocomplete.vim')
    call dein#add('Shougo/neoinclude.vim')
    call dein#add('Shougo/context_filetype.vim')
    call dein#add('Shougo/neosnippet.vim')
    call dein#add('Shougo/neosnippet-snippets')
    call dein#add('Shougo/vimproc.vim', {'build': 'make'})
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

    call dein#add('tpope/vim-endwise')
    call dein#add('tpope/vim-commentary')
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
    call dein#add('tpope/vim-vinegar')
    call dein#add('tpope/vim-pathogen')

    " Tools
    call dein#add('editorconfig/editorconfig-vim')
    call dein#add('KabbAmine/vCoolor.vim')
    call dein#add('sjl/gundo.vim')
    call dein#add('haya14busa/dein-command.vim')
    call dein#add('jamessan/vim-gnupg')
    call dein#add('tomtom/tlib_vim')
    call dein#add('tomtom/tcomment_vim')
    call dein#add('jceb/vim-orgmode')
    call dein#add('vimwiki/vimwiki')
    call dein#add('thaerkh/vim-workspace')
    call dein#add('sbdchd/neoformat')
    call dein#add('mattn/emmet-vim')
    call dein#add('mattn/webapi-vim')
    call dein#add('terryma/vim-multiple-cursors')
    call dein#add('vim-scripts/mru.vim')
    call dein#add('sophacles/vim-bundle-mako')
    call dein#add('junegunn/goyo.vim')
    call dein#add('godlygeek/tabular')
    call dein#add('raimondi/delimitmate')
    call dein#add('groenewege/vim-less')
    call dein#add('ntpeters/vim-better-whitespace')
    call dein#add('alvan/vim-closetag')

    " Interface
    call dein#add('mhinz/vim-startify')
    call dein#add('jistr/vim-nerdtree-tabs')

    " VCS
    call dein#add('tpope/vim-fugitive')
    call dein#add('gregsexton/gitv')
    call dein#add('junegunn/gv.vim')
    call dein#add('idanarye/vim-merginal')
    call dein#add('airblade/vim-gitgutter')
    call dein#add('mattn/gist-vim')
    call dein#add('lambdalisue/gina.vim')

    " Snips
    call dein#add('SirVer/ultisnips')
    call dein#add('honza/vim-snippets')

    " Languages
    " C family
    call dein#add('octol/vim-cpp-enhanced-highlight')
    call dein#add('osyo-manga/vim-reunions')
    call dein#add('osyo-manga/vim-marching')
    " Javascript
    call dein#add('pangloss/vim-javascript')
    call dein#add('mxw/vim-jsx')
    call dein#add('maksimr/vim-jsbeautify')
    call dein#add('othree/javascript-libraries-syntax')
    call dein#add('posva/vim-vue')
    call dein#add('Quramy/vim-js-pretty-template')
    call dein#add('ternjs/tern_for_vim')
    call dein#add('kchmck/vim-coffee-script')
    " Typescript
    call dein#add('HerringtonDarkholme/yats.vim')
    call dein#add('Quramy/tsuquyomi')
    " CSS/SCSS
    call dein#add('ap/vim-css-color')
    call dein#add('hail2u/vim-css3-syntax')
    call dein#add('cakebaker/scss-syntax.vim')
    call dein#add('othree/csscomplete.vim')
    " Go
    call dein#add('fatih/vim-go')
    " Php
    call dein#add('stanangeloff/php.vim')
    call dein#add('shawncplus/phpcomplete.vim')
    " Markdown
    call dein#add('plasticboy/vim-markdown')
    call dein#add('kannokanno/previm')
    call dein#add('tyru/open-browser.vim')
    " Erlang
    call dein#add('vim-erlang/vim-erlang-runtime')
    call dein#add('vim-erlang/vim-erlang-omnicomplete')
    " Ruby/Perl
    call dein#add('vim-ruby/vim-ruby')
    call dein#add('vim-perl/vim-perl')
    " Rust
    call dein#add('rust-lang/rust.vim')
    call dein#add('racer-rust/vim-racer')
    " Java
    call dein#add('artur-shaik/vim-javacomplete2')
    " Python
    call dein#add('davidhalter/jedi-vim')
    call dein#add('nvie/vim-flake8')
    call dein#add('hynek/vim-python-pep8-indent')
    " Haskell
    call dein#add('eagletmt/neco-ghc')
    " Elixir
    call dein#add('elixir-lang/vim-elixir')
    " Latex
    call dein#add('lervag/vimtex')
    call dein#add('xuhdev/vim-latex-live-preview')
    " Others
    call dein#add('derekwyatt/vim-scala')
    call dein#add('wlangstroth/vim-racket')
    call dein#add('elmcast/elm-vim')
    call dein#add('guns/vim-clojure-static')
    call dein#add('stephpy/vim-yaml')
    call dein#add('rhysd/vim-crystal')
    call dein#add('slim-template/vim-slim')
    call dein#add('dart-lang/dart-vim-plugin')
    call dein#add('ekalinin/dockerfile.vim')
    call dein#add('matt-deacalion/vim-systemd-syntax')
    call dein#add('tiagofumo/vim-nerdtree-syntax-highlight')
    call dein#add('pearofducks/ansible-vim')
    call dein#add('isobit/vim-caddyfile')
    call dein#add('tpope/vim-cucumber')

    " Required:
    call dein#end()
    call dein#save_state()
endif

" Required:
" filetype plugin indent on
" syntax enable

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif


" vim-plug
call plug#begin('~/.vim/plugged')

Plug 'w0rp/ale'
Plug 'flazz/vim-colorschemes'
Plug 'kovisoft/slimv'

call plug#end()


" vundle config
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'


" syntax
" completions

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


