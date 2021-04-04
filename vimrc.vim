" Copyright (C) 2020  Ace <teapot@aceforeverd.com>
"
" This program is free software: you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation, either version 3 of the License, or
" (at your option) any later version.
"
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with this program.  If not, see <http://www.gnu.org/licenses/>.

set nocompatible

let s:home = expand('<sfile>:p:h')
let s:common_path = s:home . '/bundle'
let s:common_pkg = s:common_path . '/pkgs'

if !has('nvim')
    let g:vimrc = s:home . '/vimrc'
else
    let g:vimrc = s:home . '/init.vim'
endif

let s:dein_repo = s:home . '/dein'

let s:before_vimrc = s:home . '/before.vim'

if filereadable(s:before_vimrc)
    execute('source ' . s:before_vimrc)
endif

if !exists('g:my_cmp_source')
    let g:my_cmp_source = 'coc'
endif

if !exists('g:my_name')
    let g:my_name = 'Ace'
endif
if !exists('g:my_email')
    let g:my_email = 'teapot@aceforeverd.com'
endif

let s:dein_path = s:dein_repo . '/repos/github.com/Shougo/dein.vim'
let &runtimepath = &runtimepath . ',' . s:dein_path . ',' . s:home

" vim plug
" ============================================================================================
let g:vim_json_syntax_conceal = 1

call plug#begin(s:common_pkg) "{{{

Plug 'bergercookie/vim-debugstring'
Plug 'airblade/vim-gitgutter'

Plug 'sheerun/vim-polyglot'

Plug 'chrisbra/unicode.vim'
Plug 'puremourning/vimspector'
let g:vimspector_enable_mappings = 'HUMAN'
Plug 'rafi/awesome-vim-colorschemes'

if g:my_cmp_source ==? 'deoplete'
    Plug 'autozimu/LanguageClient-neovim', {
                \ 'branch': 'next',
                \ 'do': 'bash install.sh',
                \ }
endif
Plug 'jsfaint/gen_tags.vim'

if has('nvim-0.5')
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
endif

Plug 'liuchengxu/vim-clap', { 'do': { -> clap#installer#force_download() } }

call plug#end() "}}}


let g:dein#install_process_timeout = 180
let g:dein#install_process_type = 'tabline'

" let $NVIM_NODE_LOG_FILE = '/tmp/nvim-node.log'
" let $NVIM_NODE_LOG_LEVEL = 'info'

if dein#load_state(s:dein_repo)
    call dein#begin(s:dein_repo)

    call dein#add(s:dein_path)
    if !has('nvim')
        " optional plugins for vim
        call dein#add('roxma/nvim-yarp')
        call dein#add('roxma/vim-hug-neovim-rpc')
    else
        " optional plugins for neovim
        call dein#add('kassio/neoterm')
        call dein#add('fszymanski/fzf-gitignore')
        " Repl
        call dein#add('hkupty/iron.nvim')
    endif

    if g:my_cmp_source ==? 'deoplete'
        call dein#add('Shougo/deoplete.nvim')
        call dein#add('deoplete-plugins/deoplete-go', {
                    \ 'build': 'make',
                    \ 'on_ft': 'go',
                    \ })
        call dein#add('Shougo/deoplete-lsp')
        call dein#add('Shougo/deoplete-terminal')
        call dein#add('deoplete-plugins/deoplete-zsh')
        call dein#add('ponko2/deoplete-fish')
        call dein#add('uplus/deoplete-solargraph', {'on_ft': 'ruby', 'lazy': 1})
        call dein#add('deoplete-plugins/deoplete-asm', {'build': 'make'})
        call dein#add('pbogut/deoplete-elm')
        call dein#add('deoplete-plugins/deoplete-jedi')
        call dein#add('ujihisa/neco-look')
        call dein#add('c9s/perlomni.vim', {'on_ft': 'perl'})
        call dein#add('clojure-vim/async-clj-omni')
    elseif g:my_cmp_source ==? 'coc'
        call dein#add('neoclide/coc.nvim', {'merged': 0, 'rev': 'release'})
        call dein#add('antoinemadec/coc-fzf')
        call dein#add('jsfaint/coc-neoinclude')
        call dein#add('neoclide/coc-neco')
    endif

    call dein#add('Shougo/neoinclude.vim')
    call dein#add('Shougo/context_filetype.vim')
    call dein#add('Shougo/neco-syntax')
    call dein#add('Shougo/neco-vim')
    call dein#add('Shougo/neoyank.vim')
    call dein#add('Shougo/echodoc.vim')

    call dein#add('voldikss/vim-floaterm')

    call dein#add('Shougo/denite.nvim')
    call dein#add('neoclide/denite-extra')
    call dein#add('ozelentok/denite-gtags')
    call dein#add('neoclide/denite-git')

    call dein#add('tpope/vim-endwise')
    call dein#add('tpope/vim-surround')
    call dein#add('tpope/vim-ragtag')
    call dein#add('tpope/vim-dispatch')
    call dein#add('tpope/vim-rhubarb')
    call dein#add('tpope/vim-abolish')
    call dein#add('tpope/vim-repeat')
    call dein#add('tpope/vim-bundler')
    call dein#add('tpope/vim-rails')
    call dein#add('tpope/vim-fireplace')
    call dein#add('tpope/vim-scriptease')
    call dein#add('tpope/vim-unimpaired')
    call dein#add('tpope/vim-salve')
    call dein#add('tpope/vim-eunuch')
    call dein#add('tpope/vim-speeddating')
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
    call dein#add('rakr/vim-one')
    call dein#add('ryanoasis/vim-devicons')
    call dein#add('mhinz/vim-startify')
    call dein#add('ntpeters/vim-better-whitespace')
    call dein#add('majutsushi/tagbar')
    call dein#add('liuchengxu/vista.vim')
    call dein#add('wincent/terminus')
    call dein#add('psliwka/vim-smoothie')
    call dein#add('chrisbra/Colorizer')
    call dein#add('junegunn/rainbow_parentheses.vim')
    call dein#add('liuchengxu/vim-which-key', {'on_cmd': ['WhichKey', 'WhichKey!']})

    call dein#add('google/vim-searchindex')
    call dein#add('embear/vim-localvimrc')

    " motion
    call dein#add('easymotion/vim-easymotion')
    call dein#add('rhysd/clever-f.vim')
    call dein#add('justinmk/vim-sneak')
    call dein#add('andymass/vim-matchup')
    " Tools
    call dein#add('editorconfig/editorconfig-vim')
    call dein#add('mattn/emmet-vim')
    call dein#add('mattn/webapi-vim')
    call dein#add('will133/vim-dirdiff')
    call dein#add('itchyny/calendar.vim')
    call dein#add('tweekmonster/startuptime.vim')

    call dein#add('alpertuna/vim-header')
    call dein#add('antoyo/vim-licenses')
    " code format
    call dein#add('sbdchd/neoformat')
    call dein#add('junegunn/vim-easy-align')
    call dein#add('godlygeek/tabular')
    " debug/test
    call dein#add('janko/vim-test')

    " VCS
    call dein#add('tpope/vim-fugitive')
    call dein#add('lambdalisue/gina.vim')
    call dein#add('junegunn/gv.vim')
    call dein#add('mattn/gist-vim')
    call dein#add('idanarye/vim-merginal')
    call dein#add('chrisbra/vim-diff-enhanced')
    call dein#add('rhysd/committia.vim')
    call dein#add('jreybert/vimagit')
    call dein#add('cohama/agit.vim')
    call dein#add('rhysd/git-messenger.vim', {
            \   'lazy' : 1,
            \   'on_cmd' : 'GitMessenger',
            \   'on_map' : '<Plug>(git-messenger)',
            \ })

    " search
    call dein#add('junegunn/fzf', {
                \ 'path': $HOME . '/.fzf',
                \ 'build': './install --all',
                \ 'merged': 0
                \ })
    call dein#add('junegunn/fzf.vim')
    call dein#add('haya14busa/incsearch.vim')

    call dein#add('mbbill/undotree')
    call dein#add('haya14busa/dein-command.vim')
    call dein#add('wsdjeg/dein-ui.vim')
    call dein#add('jamessan/vim-gnupg')
    call dein#add('jceb/vim-orgmode')

    call dein#add('tomtom/tcomment_vim')
    call dein#add('raimondi/delimitmate')
    call dein#add('chrisbra/recover.vim')
    " text object manipulate
    call dein#add('AndrewRadev/splitjoin.vim')
    call dein#add('AndrewRadev/sideways.vim')
    call dein#add('AndrewRadev/tagalong.vim')
    call dein#add('chrisbra/NrrwRgn')
    call dein#add('machakann/vim-sandwich')

    " Go
    call dein#add('fatih/vim-go')
    " c/c++/objc
    call dein#add('nacitar/a.vim')
    call dein#add('sakhnik/nvim-gdb')
    " Typescript
    call dein#add('HerringtonDarkholme/yats.vim')

    " Haskell
    call dein#add('neovimhaskell/haskell-vim')
    call dein#add('eagletmt/neco-ghc')
    call dein#add('Twinside/vim-hoogle')
    " vimL
    call dein#add('mhinz/vim-lookup')

    call dein#add('kevinoid/vim-jsonc')
    call dein#add('tweekmonster/exception.vim')
    call dein#add('tweekmonster/helpful.vim')
    " Elixir
    call dein#add('slashmili/alchemist.vim')
    " CSS/SCSS/LESS
    call dein#add('hail2u/vim-css3-syntax', {'merged': 0})
    " markdown
    call dein#add('mzlogin/vim-markdown-toc', {'on_ft': 'markdown'})
    call dein#add('iamcco/markdown-preview.nvim', {
                \ 'on_ft': ['markdown', 'pandoc.markdown', 'rmd'],
                \ 'build': 'cd app && yarn install' })
    " R
    call dein#add('jalvesaq/Nvim-R')
    " Rust
    call dein#add('rust-lang/rust.vim')
    " Perl/Ruby
    call dein#add('vim-ruby/vim-ruby')
    " Erlang
    call dein#add('vim-erlang/vim-erlang-omnicomplete')
    " Tmux
    call dein#add('tmux-plugins/vim-tmux')
    call dein#add('christoomey/vim-tmux-navigator')
    call dein#add('wellle/tmux-complete.vim')
    " Latex
    call dein#add('lervag/vimtex')
    call dein#add('xuhdev/vim-latex-live-preview', {'on_ft': 'tex'})

    call dein#add('mboughaba/i3config.vim')
    call dein#add('hashivim/vim-terraform')
    call dein#add('elmcast/elm-vim')
    call dein#add('kovisoft/slimv', {'merged': 0})
    " clojure
    call dein#add('clojure-vim/acid.nvim', {'merged': 0, 'on_ft': 'clojure'})
    " npm
    call dein#add('rhysd/npm-filetypes.vim')
    " gentoo
    call dein#add('gentoo/gentoo-syntax')

    call dein#add('chrisbra/csv.vim')
    call dein#add('rhysd/vim-grammarous')

    call dein#add('jackguo380/vim-lsp-cxx-highlight')

    call dein#end()
    call dein#save_state()
endif

" pathogen
if exists('g:load_pathogen_plugins')
    execute pathogen#infect(s:common_path . '/pog/{}')
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
    augroup gp_gui_macvim
        autocmd!
        autocmd GUIEnter * set vb t_vb=
    augroup END
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

set encoding=utf-8
scriptencoding utf-8

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
    tnoremap <C-w>m <C-\><c-n>:FloatermToggle<CR>
    tnoremap <C-w>] <C-\><c-n>:FloatermNext<CR>
    tnoremap <C-w>[ <C-\><c-n>:FloatermPrev<CR>
    nnoremap <C-w>m :FloatermToggle<CR>
    noremap <C-w>] :FloatermNext<CR>
    noremap <C-w>[ :FloatermPrev<CR>
    tnoremap <C-w>n <C-\><C-n>:FloatermNew<CR>
    nnoremap <C-w>n :FloatermNew<CR>
endfunction
if has('nvim') || has('terminal')
    call s:terminal_mapping()
endif

" map <silent> <leader><cr> :noh<cr>
nnoremap <leader>tn :tabnew<cr>
nnoremap <leader>to :tabonly<cr>
nnoremap <leader>tc :tabclose<cr>
nnoremap <leader>tm :tabmove<cr>
nnoremap ]v :tabnext<cr>
nnoremap [v :tabprevious<cr>
nnoremap <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" swith to last active tab
let g:lasttab = 1
nnoremap <Leader>ts :exe "tabn ".g:lasttab<CR>
augroup tab_boy
    autocmd!
    autocmd TabLeave * let g:lasttab = tabpagenr()
augroup END

nnoremap <Leader>ec :execute 'edit' g:vimrc<CR>

nnoremap <space>t :TagbarToggle<CR>

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
augroup gp_cursor_location
    " this one is which you're most likely to use?
   autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END

if has('mac') || has('macunix')
    set guifont=SauceCodeProNerdFontComplete-Regular:h14
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
    if has('nvim-0.5')
        let &undodir= s:common_path . '/undodir-0.5/'
    else
        let &undodir= s:common_path . '/undodir/'
    endif

    set undofile
catch
endtry

" suda.vim
command! SudaWrite exe 'w suda://%'
command! SudaRead  exe 'e suda://%'

augroup gp_filetype
    autocmd!
    autocmd BufRead,BufNewFile *.verilog,*.vlg setlocal filetype=verilog
    autocmd BufRead,BufNewFile *.log setlocal filetype=log
    autocmd BufRead,BufNewFile *.fish setlocal filetype=fish
    autocmd FileType verilog,verilog_systemverilog setlocal nosmartindent
    autocmd FileType javascript setlocal nocindent
augroup END

" fzf
nnoremap <c-p> :FZF<CR>
let g:fzf_action = {
      \ 'ctrl-a': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }

" fzf-vim
" Mapping selecting mappings
nmap <Leader><Tab> <plug>(fzf-maps-n)
imap <Leader><Tab> <plug>(fzf-maps-i)
xmap <Leader><Tab> <plug>(fzf-maps-x)
omap <Leader><Tab> <plug>(fzf-maps-o)
" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)

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

" startify
let g:startify_session_dir = '~/.vim/sessions/'
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

" vim-go
augroup VIM_GO
    autocmd!
    autocmd FileType go nnoremap <c-]> :GoDef<CR>
augroup END

" Airline
let g:airline#extensions#tabline#enabled = 1
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
        if has('termguicolors') && (has('nvim') || empty($TMUX))
            set termguicolors
        endif
    " endif
    colorscheme one

    " enable powerline on those environments
    let g:airline_powerline_fonts = 1
    let g:powerline_pycmd = 'py3'
    let g:airline_theme = 'onedark'
endif

" vim-markdown
let g:markdown_fenced_languages = ['html', 'json', 'javascript', 'c', 'bash=sh', 'vim', 'help']
" markdown-preview
let g:mkdp_auto_close = 0

" incsearch.vim
if !has('patch-8.0-1241')
    map / <Plug>(incsearch-forward)
    map ? <Plug>(incsearch-backward)
    map g/ <Plug>(incsearch-stay)
endif

" easy-align
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" denite
augroup gp_denite
    autocmd!
	autocmd FileType denite call aceforeverd#settings#denite_settings()
	autocmd FileType denite-filter call aceforeverd#settings#denite_filter_settings()
augroup END

set completeopt-=preview
" echodoc
let g:echodoc#enable_at_startup = 1

" init completion source
call aceforeverd#completion#init_cmp_source(g:my_cmp_source)

" Enable omni completion.
augroup omni_complete
    autocmd!
    " neco-ghc
    autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
augroup END

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

" vim-sneak
map <Leader>s <Plug>Sneak_s
map <Leader>S <Plug>Sneak_S

" vim-header
let g:header_auto_add_header = 0
let g:header_field_timestamp = 0
let g:header_field_modified_timestamp = 0
let g:header_field_author = g:my_name
let g:header_field_author_email = g:my_email
let g:header_field_modified_by = 0
let g:header_field_license_id = 'GPL'

" colorizer
let g:colorizer_auto_filetype='css,html,scss'

" rainbow
augroup rainbow_lisp
  autocmd!
  autocmd FileType lisp,clojure,scheme RainbowParentheses
augroup END

" tmux-complete
let g:tmuxcomplete#trigger = ''

" elm-vim
let g:elm_setup_keybindings = 0

" gen_tags
if !executable('gtags')
    let g:loaded_gentags#gtags = 1
endif

" vim-lookup
augroup gp_lookup
    autocmd!
    autocmd FileType vim nnoremap <buffer><silent> <C-]> :call lookup#lookup()<CR>
    autocmd FileType vim nnoremap gs :call plugin_browse#try_open()<CR>
augroup END

" gina
let g:gina#command#blame#formatter#format = '%su%=by %au on %ti, %ma/%in'

let g:livepreview_engine = 'xelatex'

let g:tex_flavor = 'latex'

" localvimrc
let g:localvimrc_name = [ '.lc.vim' ]

let g:better_whitespace_operator = ''

let g:nvimgdb_disable_start_keymaps = 1

" vim-license
let g:licenses_copyright_holders_name = g:my_name . ' <' . g:my_email . '>'

let s:after_vimrc = s:home . '/after.vim'
if filereadable(s:after_vimrc)
    execute('source ' . s:after_vimrc)
endif
