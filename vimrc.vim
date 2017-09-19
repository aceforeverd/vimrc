set runtimepath+=$HOME/.vim_runtime

let g:dein#install_process_timeout = 180
let g:dein#install_process_type = 'tabline'

" dein.vim
if &compatible
    set nocompatible
endif

set runtimepath+=$HOME/.vim/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('$HOME/.vim/dein')
    call dein#begin('$HOME/.vim/dein')

    " Let dein manage dein
    call dein#add('$HOME/.vim/dein/repos/github.com/Shougo/dein.vim')

    call dein#add('Shougo/vimproc.vim', {'build': 'make'})
    call dein#add('Shougo/neocomplete.vim', {'merged': 0})
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
    call dein#add('Shougo/unite-outline', {'depends': 'unite.vim'})
    call dein#add('Shougo/deol.nvim', {'on_if': '!has("gui_running")'})
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
    " call dein#add('tpope/vim-vinegar')
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
    call dein#add('Shougo/neosnippet.vim')
    call dein#add('Shougo/neosnippet-snippets')

    " interface
    call dein#add('vim-airline/vim-airline')
    call dein#add('vim-airline/vim-airline-themes')
    call dein#add('flazz/vim-colorschemes')
    call dein#add('rakr/vim-one')
    call dein#add('mhinz/vim-startify')
    call dein#add('tiagofumo/vim-nerdtree-syntax-highlight')
    call dein#add('junegunn/vim-journal')
    call dein#add('ryanoasis/vim-devicons')
    call dein#add('luochen1990/rainbow')
    call dein#add('junegunn/rainbow_parentheses.vim')
    call dein#add('ntpeters/vim-better-whitespace')
    call dein#add('majutsushi/tagbar')
    call dein#add('junegunn/goyo.vim')
    call dein#add('kshenoy/vim-signature')
    call dein#add('wincent/terminus')
    call dein#add('chrisbra/Colorizer')

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
    call dein#add('vim-utils/vim-troll-stopper')
    call dein#add('lfv89/vim-interestingwords')
    " buf
    call dein#add('jlanzarotta/bufexplorer')
    " generate helpfile from vimscript
    call dein#add('google/vimdoc')
    " code format
    call dein#add('sbdchd/neoformat')
    call dein#add('rhysd/vim-clang-format')
    call dein#add('junegunn/vim-easy-align')
    call dein#add('godlygeek/tabular')
    " debug/test
    call dein#add('janko-m/vim-test')
    call dein#add('idanarye/vim-vebugger')
    call dein#add('thinca/vim-quickrun')

    " VCS
    call dein#add('tpope/vim-fugitive')
    call dein#add('lambdalisue/gina.vim')
    call dein#add('junegunn/gv.vim')
    call dein#add('gregsexton/gitv')
    call dein#add('mattn/gist-vim')
    call dein#add('mhinz/vim-signify')
    call dein#add('idanarye/vim-merginal')
    call dein#add('chrisbra/vim-diff-enhanced')
    call dein#add('rhysd/committia.vim')
    call dein#add('jreybert/vimagit')
    call dein#add('cohama/agit.vim')

    " search
    call dein#add('ctrlpvim/ctrlp.vim')
    call dein#add('haya14busa/incsearch.vim')
    call dein#add('mhinz/vim-grepper')
    call dein#add('dyng/ctrlsf.vim')
    call dein#add('wincent/ferret')
    call dein#add('osyo-manga/vim-anzu')

    call dein#add('mbbill/undotree')
    call dein#add('haya14busa/dein-command.vim')
    call dein#add('jamessan/vim-gnupg')
    call dein#add('jceb/vim-orgmode')
    call dein#add('vimwiki/vimwiki')
    call dein#add('thaerkh/vim-workspace')
    " comment
    call dein#add('scrooloose/nerdcommenter')
    call dein#add('tomtom/tcomment_vim')

    call dein#add('raimondi/delimitmate')
    call dein#add('alvan/vim-closetag')

    call dein#add('sophacles/vim-bundle-mako')
    call dein#add('chrisbra/recover.vim')
    call dein#add('chrisbra/SudoEdit.vim')
    " text object manipulate
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

    " Languages
    " Go
    call dein#add('fatih/vim-go')
    " c/c++/objc
    call dein#add('octol/vim-cpp-enhanced-highlight')
    " call dein#add('osyo-manga/vim-marching')
    call dein#add('Rip-Rip/clang_complete', {
                \ 'build': 'make install'
                \ })
    "" Vim bindings for rtags, llvm/clang based c++ code indexer
    call dein#add('lyuts/vim-rtags', {'on_ft': 'cpp'})
    " Javascripts/Typescript/...
    call dein#add('pangloss/vim-javascript')
    call dein#add('othree/javascript-libraries-syntax.vim')
    call dein#add('Quramy/vim-js-pretty-template')
    call dein#add('maksimr/vim-jsbeautify')
    call dein#add('marijnh/tern_for_vim')
    call dein#add('HerringtonDarkholme/yats.vim')
    call dein#add('Quramy/tsuquyomi', {'on_ft': 'typescript'})
    call dein#add('mxw/vim-jsx')
    call dein#add('kchmck/vim-coffee-script')
    call dein#add('posva/vim-vue')
    " Haskell
    call dein#add('neovimhaskell/haskell-vim')
    call dein#add('eagletmt/neco-ghc')
    " Html
    call dein#add('othree/html5.vim')
    " vimL
    call dein#add('mhinz/vim-lookup')
    call dein#add('tweekmonster/helpful.vim')
    call dein#add('vim-jp/vital.vim')
    " Elixir
    call dein#add('slashmili/alchemist.vim')
    call dein#add('elixir-lang/vim-elixir')
    " Java/Kotlin
    call dein#add('artur-shaik/vim-javacomplete2')
    call dein#add('udalov/kotlin-vim')
    " CSS/SCSS/LESS
    call dein#add('groenewege/vim-less')
    "" merged: 0, conflict with othree/html5
    call dein#add('hail2u/vim-css3-syntax', {'on_ft': ['css', 'scss', 'html']})
    "" merged: 0, conflict with othree/html5 and many
    call dein#add('ap/vim-css-color', {'merged': 0})
    call dein#add('othree/csscomplete.vim')
    " Python
    call dein#add('nvie/vim-flake8')
    call dein#add('davidhalter/jedi-vim')
    call dein#add('alfredodeza/pytest.vim')
    call dein#add('jmcantrell/vim-virtualenv')
    call dein#add('vimjas/vim-python-pep8-indent')
    call dein#add('python-rope/ropevim')
    " Markdown
    call dein#add('tyru/open-browser.vim')
    call dein#add('plasticboy/vim-markdown')

    " Php
    call dein#add('stanangeloff/php.vim')
    call dein#add('shawncplus/phpcomplete.vim')
    " R
    call dein#add('jalvesaq/Nvim-R')
    " Rust
    call dein#add('rust-lang/rust.vim')
    call dein#add('racer-rust/vim-racer')
    " Perl/Ruby
    call dein#add('vim-ruby/vim-ruby')
    call dein#add('vim-perl/vim-perl', {
        \ 'rev': 'dev',
        \ 'on_ft': 'perl',
        \ 'build': 'make clean carp dancer highlight-all-pragmas moose test-more try-tiny'
        \ })
    call dein#add('vim-perl/vim-perl6')
    " Salt
    call dein#add('saltstack/salt-vim')
    " Erlang
    call dein#add('vim-erlang/vim-erlang-runtime')
    call dein#add('vim-erlang/vim-erlang-omnicomplete')
    " Tmux
    call dein#add('benmills/vimux')
    call dein#add('christoomey/vim-tmux-navigator', {'on_if': '!empty($TMUX)'})
    call dein#add('tmux-plugins/vim-tmux')
    call dein#add('edkolev/tmuxline.vim', {'on_if': '!empty($TMUX)'})
    " Lisp
    call dein#add('kovisoft/slimv')
    " Latex
    call dein#add('lervag/vimtex')
    call dein#add('xuhdev/vim-latex-live-preview')
    " Jsonnet
    call dein#add('google/vim-jsonnet')
    " Json
    call dein#add('elzr/vim-json')
    call dein#add('rodjek/vim-puppet')
    call dein#add('digitaltoad/vim-pug')
    call dein#add('exu/pgsql.vim')
    call dein#add('zah/nim.vim')
    " lua
    call dein#add('tbastos/vim-lua')
    " swift
    call dein#add('keith/swift.vim')
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
    call dein#add('elmcast/elm-vim')
    " plantuml
    call dein#add('scrooloose/vim-slumlord')
    call dein#add('aklt/plantuml-syntax')
    " clojure
    call dein#add('guns/vim-clojure-static')
    call dein#add('guns/vim-sexp')
    " npm
    call dein#add('rhysd/npm-filetypes.vim')
    " gentoo
    call dein#add('gentoo/gentoo-syntax')

    call dein#add('dart-lang/dart-vim-plugin')
    call dein#add('derekwyatt/vim-scala')
    call dein#add('slim-template/vim-slim')
    call dein#add('chrisbra/csv.vim')

    call dein#add('rhysd/vim-grammarous', {'merged': 0})

    call dein#end()
    call dein#save_state()
endif


" pathogen
" add plugins in ~/.vim/bundle
execute pathogen#infect('~/.vim/bundle/{}')

" vim plug
" ============================================================================================
call plug#begin('~/.vim/vimPlug')

Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --key-bindings --no-completion'}
Plug 'junegunn/fzf.vim'
Plug 'w0rp/ale'

Plug 'junegunn/vim-emoji'
" Plug 'chrisbra/unicode.vim'
Plug 'scrooloose/nerdtree'
" Plug 'jistr/vim-nerdtree-tabs'
Plug 'alvan/vim-php-manual', {'for': 'php'}

Plug 'wincent/command-t', {'do': 'cd ruby/command-t/ext/command-t && make clean && ruby extconf.rb && make'}

function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    if has('nvim')
      !cargo build --release
    else
      !cargo build --release --no-default-features --features json-rpc
    endif
  endif
endfunction

Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
Plug 'xolox/vim-misc', {'for': 'lua'}
Plug 'xolox/vim-lua-ftplugin', {'for': 'lua'}
Plug 'c9s/perlomni.vim', {'for': 'perl'}
Plug 'vhda/verilog_systemverilog.vim', {'for': 'verilog'}
" plugin library
" Plug 'google/vim-maktaba'
" easy configuration of maktaba plugins.
" Plug 'google/vim-glaive'
" (Syn)tax (cop)y-p(a)s(te)
" Plug 'google/vim-syncopate'
Plug 'Rykka/colorv.vim'
Plug 'justinmk/vim-dirvish'

Plug 'johngrib/vim-game-code-break', {'on': 'VimGameCodeBreak'}

call plug#end()

source ~/.vim_runtime/extra.vim
source ~/.vim_runtime/neocomplete.vim

" powerline & devicon
if $TERM=~'linux'
    " disable
    let g:webdevicons_enable = 0
    colorscheme torte
elseif $TERM=~'xterm-256color' || has('gui_running')
    " Enable Nerd tree folder icons
    if has('gui_running')
        let g:WebDevIconsUnicodeDecorateFolderNodes = 1
        let g:DevIconsEnableFolderExtensionPatternMatching = 1
    endif

    let g:NERDTreeFileExtensionHighlightFullName = 1
    let g:NERDTreeExactMatchHighlightFullName = 1
    let g:NERDTreePatternMatchHighlightFullName = 1
    " Highlight folders using exact match
    let g:NERDTreeHighlightFolders = 1 " enables folder icon highlighting using exact match
    let g:NERDTreeHighlightFoldersFullName = 1 " highlights the folder name

    let g:airline_powerline_fonts = 1

    let g:airline_theme = 'onedark'

    colorscheme one

    set termguicolors
    set background=dark

endif

if !empty($TMUX)
    set notermguicolors
    colorscheme onedark
    let g:airline_powerline_fonts = 1
    set cursorline
endif


autocmd FileType gentoo-package-use,gentoo-package-keywords let b:delimitMate_matchpairs = "(:),[:],{:}"

highlight SpellBad ctermfg=050 ctermbg=088 guifg=#00ffd7 guibg=#870000

let g:racer_cmd = '~/.local/bin/racer'

let g:marching_enable_neocomplete =  1
" let g:marching_clang_command = '/usr/lib64/llvm/5/bin/clang'

let g:rtagsRcCmd = '/home/ace/.local/bin/rtags'

" php-manual
let g:php_manual_online_search_shortcut = '<Leader>ph'

" vim-sort-motion
let g:sort_motion = '<Leader>sm'
let g:sort_motion_lines = '<Leader>sml'
let g:sort_motion_visual = '<Leader>sm'

" colorv
let g:colorv_no_global_map = 1

" vim-anzu
nmap n <Plug>(anzu-n-with-echo)
nmap N <plug>(anzu-N-with-echo)
nmap * <Plug>(anzu-star-with-echo)
nmap # <Plug>(anzu-sharp-with-echo)
nmap g* g*<Plug>(anzu-update-search-status-with-echo)
nmap g# g#<Plug>(anzu-update-search-status-with-echo)

nmap <Esc><Esc> <Plug>(anzu-clear-search-status)

let g:workspace_autosave_ignore = ['gitcommit']

let g:tcommentMaps = 0

" dirvish
nmap <Leader>v <Plug>(dirvish_up)

nnoremap <silent> <leader>k :call InterestingWords('n')<cr>
nnoremap <silent> <leader>K :call UncolorAllWords()<cr>
let g:interestingWordsRandomiseColors = 1
