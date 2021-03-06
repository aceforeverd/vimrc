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

call plug#begin(s:common_pkg) "{{{

if !has('nvim-0.6.0')
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    let g:airline#extensions#tabline#enabled = 1
    let g:airline_detect_modified=1
    let g:airline_detect_paste=1
    let g:airline_theme='onedark'
    let g:airline_powerline_fonts = 1

    Plug 'airblade/vim-gitgutter'
    omap ih <Plug>(GitGutterTextObjectInnerPending)
    omap ah <Plug>(GitGutterTextObjectOuterPending)
    xmap ih <Plug>(GitGutterTextObjectInnerVisual)
    xmap ah <Plug>(GitGutterTextObjectOuterVisual)
    let g:gitgutter_sign_added = '+'
    let g:gitgutter_sign_modified = '~'
    if has('nvim-0.4.0')
        let g:gitgutter_highlight_linenrs = 1
    endif
endif

Plug 'chrisbra/unicode.vim'

Plug 'pechorin/any-jump.vim'
Plug 'wincent/ferret'
let g:FerretMap = 0

Plug 'google/vim-maktaba'
Plug 'google/vim-coverage'

Plug 'kkoomen/vim-doge', {'do': { -> doge#install({ 'headless': 1 }) }}

Plug 'sheerun/vim-polyglot'
let g:polyglot_disabled = ['sensible', 'go']
let g:vim_json_syntax_conceal = 1

let g:vimspector_enable_mappings = 'HUMAN'
Plug 'rafi/awesome-vim-colorschemes'

if g:my_cmp_source ==? 'deoplete'
    Plug 'autozimu/LanguageClient-neovim', {
                \ 'branch': 'next',
                \ 'do': 'bash install.sh',
                \ }
endif

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
        call dein#add('Olical/conjure')
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
        call dein#add('deoplete-plugins/deoplete-jedi')
        call dein#add('ujihisa/neco-look')
        call dein#add('c9s/perlomni.vim', {'on_ft': 'perl'})
        call dein#add('clojure-vim/async-clj-omni')
        call dein#add('Shougo/neoinclude.vim')
        call dein#add('Shougo/neosnippet-snippets')
        call dein#add('Shougo/neosnippet.vim')
    elseif g:my_cmp_source ==? 'coc'
        call dein#add('neoclide/coc.nvim', {'merged': 0, 'rev': 'release'})
        call dein#add('antoinemadec/coc-fzf')
        call dein#add('neoclide/coc-neco')
    endif

    call dein#add('Shougo/context_filetype.vim')
    call dein#add('Shougo/neco-syntax')
    call dein#add('Shougo/neco-vim')
    call dein#add('Shougo/neoyank.vim')
    call dein#add('Shougo/echodoc.vim')

    call dein#add('voldikss/vim-floaterm')

    call dein#add('Shougo/denite.nvim')
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
    call dein#add('tpope/vim-obsession')
    call dein#add('tpope/vim-tbone')
    call dein#add('tpope/vim-dadbod')
    call dein#add('tpope/vim-projectionist')

    call dein#add('lambdalisue/suda.vim')

    call dein#add('airblade/vim-rooter')

    " snippets
    call dein#add('honza/vim-snippets')

    " interface
    call dein#add('preservim/tagbar')
    call dein#add('ryanoasis/vim-devicons')
    call dein#add('mhinz/vim-startify')
    call dein#add('ntpeters/vim-better-whitespace')
    call dein#add('liuchengxu/vista.vim')
    call dein#add('wincent/terminus')
    call dein#add('liuchengxu/vim-which-key', {'on_cmd': ['WhichKey', 'WhichKey!']})

    call dein#add('embear/vim-localvimrc')

    " motion
    call dein#add('easymotion/vim-easymotion')
    call dein#add('rhysd/clever-f.vim')
    call dein#add('justinmk/vim-sneak')
    call dein#add('andymass/vim-matchup')
    " Tools
    call dein#add('editorconfig/editorconfig-vim')
    call dein#add('mattn/emmet-vim')
    call dein#add('will133/vim-dirdiff')
    call dein#add('dstein64/vim-startuptime')
    call dein#add('jsfaint/gen_tags.vim')

    call dein#add('alpertuna/vim-header')
    call dein#add('antoyo/vim-licenses')
    " code format
    call dein#add('sbdchd/neoformat')
    call dein#add('junegunn/vim-easy-align')
    " debug/test
    call dein#add('janko/vim-test')
    call dein#add('jpalardy/vim-slime')

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
            \   'on_map' : '<Plug>(git-messenger',
            \ })

    " search
    call dein#add('junegunn/fzf', {
                \ 'path': $HOME . '/.fzf',
                \ 'build': './install --all',
                \ 'merged': 0
                \ })
    call dein#add('junegunn/fzf.vim')

    call dein#add('mbbill/undotree')
    call dein#add('wsdjeg/dein-ui.vim')
    call dein#add('jamessan/vim-gnupg')

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
    call dein#add('sakhnik/nvim-gdb')
    call dein#add('puremourning/vimspector')
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
    " Tmux
    call dein#add('tmux-plugins/vim-tmux')
    call dein#add('christoomey/vim-tmux-navigator')
    call dein#add('wellle/tmux-complete.vim')
    call dein#add('preservim/vimux')
    " Latex
    " merged = 0 beacue E944: Reverse range in character class
    call dein#add('lervag/vimtex', {'merged': 0})

    call dein#add('kovisoft/slimv', {'merged': 0})
    " clojure
    call dein#add('clojure-vim/acid.nvim', {'on_ft': 'clojure'})
    " npm
    call dein#add('rhysd/npm-filetypes.vim')
    " gentoo
    call dein#add('gentoo/gentoo-syntax')

    call dein#add('chrisbra/csv.vim')

    call dein#add('jackguo380/vim-lsp-cxx-highlight')
    call dein#add('cdelledonne/vim-cmake')

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
    let g:floaterm_width = 0.8
    let g:floaterm_height = 0.8
    tnoremap <C-w>j <C-\><C-n><C-w>j
    tnoremap <C-w>k <C-\><C-n><C-w>k
    tnoremap <C-w>l <C-\><C-n><C-w>l
    tnoremap <C-w>h <C-\><C-n><C-w>h
    tnoremap <C-w>m <C-\><c-n>:FloatermToggle<CR>
    tnoremap <C-w>] <C-\><c-n>:FloatermNext<CR>
    tnoremap <C-w>[ <C-\><c-n>:FloatermPrev<CR>
    tnoremap <C-w>a <C-\><C-n>:FloatermNew<CR>
    tnoremap <C-w>e <C-\><C-n>:FloatermKill<CR>
    tnoremap <c-w>n <c-\><c-n>
    nnoremap <C-w>m :FloatermToggle<CR>
    " paste register content in terminal mode
    tnoremap <expr> <C-e> '<C-\><C-N>"'.nr2char(getchar()).'pi'
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

nnoremap <space>t :<c-u>TagbarToggle<CR>

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

" dein.vim
function! s:delete_path(path) abort
    delete(a:path, 'rf')
    return a:path
endfunction
command! DeinClean exe 'call map(dein#check_clean(), { _, val -> delete(val, "rf") })'

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
command! -bar -bang IMaps exe 'call fzf#vim#maps("i", <bang>0)'
command! -bar -bang VMaps exe 'call fzf#vim#maps("v", <bang>0)'
command! -bar -bang XMaps exe 'call fzf#vim#maps("x", <bang>0)'
command! -bar -bang OMaps exe 'call fzf#vim#maps("o", <bang>0)'
command! -bar -bang TMaps exe 'call fzf#vim#maps("t", <bang>0)'
command! -bar -bang SMaps exe 'call fzf#vim#maps("s", <bang>0)'
" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)

" from vim-rsi
" <c-a> & <c-e> -> <HOME> & <END>, <c-b> & <c-f> -> forward & backward
inoremap        <C-A> <C-O>^
inoremap   <C-X><C-A> <C-A>
inoremap <expr> <C-E> col('.')>strlen(getline('.'))<bar><bar>pumvisible()?"\<Lt>C-E>":"\<Lt>End>"
inoremap <C-\><C-E> <C-E>

cnoremap        <C-A> <Home>
cnoremap        <C-B> <Left>
cnoremap   <C-X><C-A> <C-A>
cnoremap <expr> <C-F> getcmdpos()>strlen(getcmdline())?&cedit:"\<Lt>Right>"

if executable('rg')
    set grepprg=rg\ --vimgrep
endif

" tmux navigator
let g:tmux_navigator_no_mappings = 1

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
endif

" vim-markdown
let g:markdown_fenced_languages = ['html', 'json', 'javascript', 'c', 'bash=sh', 'vim', 'help']
" markdown-preview
let g:mkdp_auto_close = 0

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

" Enable omni completion.
augroup omni_complete
    autocmd!
    " neco-ghc
    autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
augroup END

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

" tmux-complete
let g:tmuxcomplete#trigger = ''

" vim-lookup
augroup gp_lookup
    autocmd!
    autocmd FileType vim nnoremap <buffer><silent> <LocalLeader><C-]> :call lookup#lookup()<CR>
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

" git-messenger
map <Leader>gm <Plug>(git-messenger)

" neoformat
let g:neoformat_enabled_lua = ['luaformat']

" vim-license
let g:licenses_copyright_holders_name = g:my_name . ' <' . g:my_email . '>'

if aceforeverd#util#has_float()
    " matchup
    let g:matchup_matchparen_offscreen = {'method': 'popup'}
endif

" gen_tags.vim
let g:gen_tags#ctags_auto_update = 0
let g:gen_tags#gtags_auto_update = 0
let g:gen_tags#ctags_opts = '--links=no'
let g:gen_tags#gtags_opts = '--skip-symlink'

" vim-go
let g:go_fmt_autosave = 0
let g:go_mod_fmt_autosave = 0
let g:go_doc_popup_window = 1
let g:go_term_enabled = 1
let g:go_def_mapping_enabled = 0
let g:go_doc_keywordprg_enabled = 0
augroup gp_vim_go
    autocmd!
    autocmd FileType go nnoremap <c-]> :GoDef<CR>
augroup END


if has('nvim-0.5')
    lua require('aceforeverd')
endif

" init completion source
call aceforeverd#completion#init_cmp_source(g:my_cmp_source)

let s:after_vimrc = s:home . '/after.vim'
if filereadable(s:after_vimrc)
    execute('source ' . s:after_vimrc)
endif
