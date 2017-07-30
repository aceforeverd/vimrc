set runtimepath+=~/.vim/dein.vim/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('~/.vim/dein.vim')
    call dein#begin('~/.vim/dein.vim')

    " Let dein manage dein
    " Required:
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
    call dein#add('Shougo/vimproc.vim', {'build': 'make'})

    " tools
    call dein#add('tpope/vim-pathogen')
    call dein#add('tpope/vim-fugitive')
    call dein#add('gregsexton/gitv')
    call dein#add('junegunn/gv.vim')
    call dein#add('idanarye/vim-merginal')
    call dein#add('KabbAmine/vCoolor.vim')
    call dein#add('haya14busa/dein-command.vim')
    call dein#add('jamessan/vim-gnupg')
    call dein#add('tomtom/tlib_vim')
    call dein#add('tomtom/tcomment_vim')
    call dein#add('mattn/gist-vim')


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

call plug#end()


" vundle config
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'rdnetto/YCM-Generator'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'HerringtonDarkholme/yats.vim'
Plugin 'Quramy/vim-js-pretty-template'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'kannokanno/previm'
Plugin 'tyru/open-browser.vim'
Plugin 'raimondi/delimitmate'
Plugin 'fatih/vim-go'
Plugin 'groenewege/vim-less'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'mattn/emmet-vim'
Plugin 'mattn/webapi-vim'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'maksimr/vim-jsbeautify'
Plugin 'mru.vim'
Plugin 'sophacles/vim-bundle-mako'
Plugin 'jceb/vim-orgmode'
Plugin 'vimwiki/vimwiki'
Plugin 'thaerkh/vim-workspace'
Plugin 'ap/vim-css-color'
Plugin 'mhinz/vim-startify'
Plugin 'junegunn/goyo.vim'
"Plugin 'neomake/neomake'
Plugin 'sbdchd/neoformat'
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

" completions
Plugin 'artur-shaik/vim-javacomplete2'
Plugin 'davidhalter/jedi-vim'
Plugin 'ternjs/tern_for_vim'
Plugin 'othree/csscomplete.vim'
Plugin 'Quramy/tsuquyomi'
Plugin 'shawncplus/phpcomplete.vim'
Plugin 'racer-rust/vim-racer'
Plugin 'osyo-manga/vim-reunions'
Plugin 'osyo-manga/vim-marching'
Plugin 'eagletmt/neco-ghc'
Plugin 'vim-erlang/vim-erlang-omnicomplete'

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


