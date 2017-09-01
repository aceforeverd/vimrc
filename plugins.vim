set runtimepath+=~/.vim/dein.vim/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('~/.vim/dein.vim')
    call dein#begin('~/.vim/dein.vim')

    call dein#add('~/.vim/dein.vim/repos/github.com/Shougo/dein.vim')

    call dein#add('Shougo/neocomplete.vim', {'merged': 0})
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
    call dein#add('ujihisa/neco-look')

    call dein#add('tpope/vim-surround')
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
    call dein#add('tpope/vim-pathogen')
    call dein#add('tpope/vim-eunuch')
    call dein#add('tpope/vim-salve')
    call dein#add('tpope/vim-speeddating')
    call dein#add('tpope/vim-projectionist')

    " search
    call dein#add('mhinz/vim-grepper')
    call dein#add('ctrlpvim/ctrlp.vim')
    call dein#add('dyng/ctrlsf.vim')
    call dein#add('google/vim-searchindex')
    call dein#add('wincent/ferret')
    " Tools
    call dein#add('editorconfig/editorconfig-vim')
    call dein#add('KabbAmine/vCoolor.vim')
    call dein#add('sjl/gundo.vim')
    call dein#add('mbbill/undotree')
    call dein#add('haya14busa/dein-command.vim')
    call dein#add('jamessan/vim-gnupg')
    call dein#add('jceb/vim-orgmode')
    call dein#add('vimwiki/vimwiki')
    call dein#add('thaerkh/vim-workspace')
    call dein#add('tomtom/tlib_vim')
    call dein#add('chrisbra/recover.vim')
    call dein#add('chrisbra/SudoEdit.vim')
    " comment
    call dein#add('tomtom/tcomment_vim')
    call dein#add('scrooloose/nerdcommenter')
    " format
    call dein#add('sbdchd/neoformat')
    call dein#add('junegunn/vim-easy-align')
    call dein#add('rhysd/vim-clang-format')
    " buf
    call dein#add('jlanzarotta/bufexplorer')
    " generate helpfile from vimscript
    call dein#add('google/vimdoc')

    call dein#add('mattn/emmet-vim')
    call dein#add('mattn/webapi-vim')
    " text manipulate
    call dein#add('terryma/vim-multiple-cursors')
    call dein#add('michaeljsmith/vim-indent-object')
    call dein#add('tommcdo/vim-exchange')
    call dein#add('matze/vim-move')
    call dein#add('christoomey/vim-sort-motion')
    call dein#add('AndrewRadev/switch.vim')
    call dein#add('AndrewRadev/splitjoin.vim')
    call dein#add('AndrewRadev/sideways.vim')
    call dein#add('chrisbra/NrrwRgn')
    call dein#add('machakann/vim-sandwich')
    " motions
    call dein#add('easymotion/vim-easymotion')
    call dein#add('rhysd/clever-f.vim')

    call dein#add('sophacles/vim-bundle-mako')
    call dein#add('godlygeek/tabular')
    call dein#add('raimondi/delimitmate')
    call dein#add('alvan/vim-closetag')
    " database tool
    call dein#add('vim-scripts/dbext.vim')

    " Interface
    call dein#add('mhinz/vim-startify')
    call dein#add('luochen1990/rainbow')
    call dein#add('junegunn/goyo.vim')
    call dein#add('ntpeters/vim-better-whitespace')
    call dein#add('kshenoy/vim-signature')
    call dein#add('majutsushi/tagbar')

    " VCS
    call dein#add('tpope/vim-fugitive')
    call dein#add('gregsexton/gitv')
    call dein#add('junegunn/gv.vim')
    call dein#add('idanarye/vim-merginal')
    call dein#add('mhinz/vim-signify')
    call dein#add('mattn/gist-vim')
    call dein#add('lambdalisue/gina.vim')
    call dein#add('airblade/vim-rooter')

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
    call dein#add('othree/javascript-libraries-syntax.vim')
    call dein#add('posva/vim-vue')
    call dein#add('Quramy/vim-js-pretty-template')
    call dein#add('ternjs/tern_for_vim')
    call dein#add('kchmck/vim-coffee-script')
    call dein#add('groenewege/vim-less')
    " Typescript
    call dein#add('HerringtonDarkholme/yats.vim')
    call dein#add('Quramy/tsuquyomi', {'on_ft': 'typescript'})
    " html
    call dein#add('Valloric/MatchTagAlways')
    call dein#add('othree/html5.vim')
    " CSS/SCSS
    "" merged: 0, conflict with othree/html5
    call dein#add('hail2u/vim-css3-syntax', {'merged': 0})
    "" merged: 0, conflict with othree/html5 and many
    call dein#add('ap/vim-css-color', {'merged': 0})
    call dein#add('othree/csscomplete.vim')
    " Go
    call dein#add('fatih/vim-go')
    " Php
    call dein#add('stanangeloff/php.vim')
    call dein#add('shawncplus/phpcomplete.vim')
    " Markdown
    call dein#add('plasticboy/vim-markdown')
    call dein#add('tyru/open-browser.vim')
    " Erlang
    call dein#add('vim-erlang/vim-erlang-runtime')
    call dein#add('vim-erlang/vim-erlang-omnicomplete')
    " Ruby/Perl
    call dein#add('vim-ruby/vim-ruby')
    call dein#add('vim-perl/vim-perl', {
        \ 'rev': 'dev',
        \ 'on_ft': 'perl',
        \ 'build': 'make clean carp dancer highlight-all-pragmas moose test-more try-tiny'
        \ })
    call dein#add('vim-perl/vim-perl6')
    " Rust
    call dein#add('rust-lang/rust.vim')
    call dein#add('racer-rust/vim-racer')
    " Java/Kotlin
    call dein#add('artur-shaik/vim-javacomplete2')
    call dein#add('udalov/kotlin-vim')
    " Python
    call dein#add('davidhalter/jedi-vim')
    call dein#add('nvie/vim-flake8')
    call dein#add('hynek/vim-python-pep8-indent')
    " Haskell
    call dein#add('neovimhaskell/haskell-vim')
    call dein#add('eagletmt/neco-ghc')
    " Elixir
    call dein#add('elixir-lang/vim-elixir')
    call dein#add('slashmili/alchemist.vim')
    " Latex
    call dein#add('lervag/vimtex')
    call dein#add('xuhdev/vim-latex-live-preview')
    " Lisp
    call dein#add('kovisoft/slimv')
    " vimL
    call dein#add('mhinz/vim-lookup')
    call dein#add('tweekmonster/helpful.vim')
    call dein#add('vim-jp/vital.vim')
    " R
    call dein#add('jalvesaq/Nvim-R')
    " Tmux
    call dein#add('benmills/vimux')
    call dein#add('christoomey/vim-tmux-navigator')
    call dein#add('tmux-plugins/vim-tmux')
    " Others
    call dein#add('exu/pgsql.vim')
    call dein#add('zah/nim.vim')
    " lua
    call dein#add('tbastos/vim-lua')
    " swift
    call dein#add('keith/swift.vim')
    call dein#add('jparise/vim-graphql')
    call dein#add('PotatoesMaster/i3-vim-syntax')
    call dein#add('arrufat/vala.vim')
    call dein#add('cespare/vim-toml')
    call dein#add('derekwyatt/vim-scala')
    call dein#add('wlangstroth/vim-racket')
    call dein#add('elmcast/elm-vim')
    " clojure
    call dein#add('guns/vim-clojure-static')
    call dein#add('guns/vim-sexp')

    call dein#add('rhysd/vim-crystal')
    call dein#add('slim-template/vim-slim')
    call dein#add('dart-lang/dart-vim-plugin')
    call dein#add('ekalinin/dockerfile.vim')
    call dein#add('matt-deacalion/vim-systemd-syntax')
    " YAML playbooks, Jinja2 templates, and Ansible's hosts files.
    call dein#add('pearofducks/ansible-vim')
    call dein#add('stephpy/vim-yaml')

    call dein#add('isobit/vim-caddyfile')
    call dein#add('tpope/vim-cucumber')
    call dein#add('tpope/vim-liquid')
    call dein#add('ekalinin/dockerfile.vim')
    call dein#add('solarnz/thrift.vim')
    call dein#add('elzr/vim-json')
    " LanguageTool
    call dein#add('rhysd/vim-grammarous')


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
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --key-bindings --no-completion'}
Plug 'junegunn/fzf.vim'

Plug 'scrooloose/nerdtree'
" problem integrate with startify
" Plug 'jistr/vim-nerdtree-tabs'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    if has('nvim')
      !cargo build --release
    else
      !cargo build --release --no-default-features --features json-rpc
    endif
  endif
endfunction

" uncomment this only if you've installed cargo
" Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
"
" uncomment this only if you've install gnu global
" Plug 'jsfaint/gen_tags.vim'

call plug#end()


