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
    elseif g:my_cmp_source ==? 'coc'
        call dein#add('neoclide/coc.nvim', {'merged': 0, 'rev': 'release'})
        call dein#add('antoinemadec/coc-fzf')
        call dein#add('jsfaint/coc-neoinclude')
        call dein#add('neoclide/coc-neco')
    endif

    call dein#add('Shougo/neoinclude.vim')
    call dein#add('Shougo/context_filetype.vim')
    call dein#add('Shougo/neco-syntax')
    call dein#add('Shougo/denite.nvim')
    call dein#add('Shougo/neco-vim')
    call dein#add('Shougo/neoyank.vim')
    call dein#add('Shougo/echodoc.vim')
    call dein#add('Shougo/deol.nvim')

    call dein#add('neoclide/denite-extra')
    call dein#add('ozelentok/denite-gtags')

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
    call dein#add('wincent/terminus')
    call dein#add('chrisbra/Colorizer')
    call dein#add('junegunn/rainbow_parentheses.vim')

    call dein#add('google/vim-searchindex')
    call dein#add('embear/vim-localvimrc')

    " motion
    call dein#add('easymotion/vim-easymotion')
    call dein#add('rhysd/clever-f.vim')
    call dein#add('justinmk/vim-sneak')
    " Tools
    call dein#add('editorconfig/editorconfig-vim')
    call dein#add('mattn/emmet-vim')
    call dein#add('mattn/webapi-vim')
    call dein#add('will133/vim-dirdiff')
    call dein#add('itchyny/calendar.vim')
    call dein#add('jsfaint/gen_tags.vim')
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
    call dein#add('neoclide/denite-git')
    call dein#add('rhysd/git-messenger.vim', {
            \   'lazy' : 1,
            \   'on_cmd' : 'GitMessenger',
            \   'on_map' : '<Plug>(git-messenger)',
            \ })

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
    call dein#add('wsdjeg/dein-ui.vim')
    call dein#add('jamessan/vim-gnupg')
    call dein#add('jceb/vim-orgmode')

    " comment
    call dein#add('tomtom/tcomment_vim')

    call dein#add('raimondi/delimitmate')
    call dein#add('alvan/vim-closetag')

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
    call dein#add('c9s/perlomni.vim', {'on_ft': 'perl'})
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
    " elm
    call dein#add('elmcast/elm-vim')
    call dein#add('kovisoft/slimv', {'merged': 0})
    " clojure
    call dein#add('clojure-vim/async-clj-omni')
    call dein#add('clojure-vim/acid.nvim', {'merged': 0})
    " npm
    call dein#add('rhysd/npm-filetypes.vim')
    " gentoo
    call dein#add('gentoo/gentoo-syntax')

    call dein#add('chrisbra/csv.vim')
    call dein#add('rhysd/vim-grammarous')

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
    set undodir=$HOME/.vim/temp_dirs/undodir/
    set undofile
catch
endtry

" suda.vim
command! SudaWrite exe 'w suda://%'
command! SudaRead  exe 'e suda://%'

augroup gp_filetype
    autocmd!
    autocmd BufRead,BufNewFile *.verilog,*.vlg setlocal filetype=verilog
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
	autocmd FileType denite call s:denite_settings()
	autocmd FileType denite-filter call s:denite_filter_settings()
augroup END

function! s:denite_filter_settings() abort
    imap <silent><buffer> <C-o> <Plug>(denite_filter_quit)
endfunction

function! s:denite_settings() abort
    nnoremap <silent><buffer><expr> <CR>
                \ denite#do_map('do_action')
    nnoremap <silent><buffer><expr> d
                \ denite#do_map('do_action', 'delete')
    nnoremap <silent><buffer><expr> p
                \ denite#do_map('do_action', 'preview')
    nnoremap <silent><buffer><expr> q
                \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> i
                \ denite#do_map('open_filter_buffer')
    nnoremap <silent><buffer><expr> <Space>
                \ denite#do_map('toggle_select').'j'

    " Change matchers.
    call denite#custom#source(
                \ 'file_mru', 'matchers', ['matcher/fuzzy', 'matcher/project_files'])
    call denite#custom#source(
                \ 'file/rec', 'matchers', ['matcher/cpsm'])

    " Change default action.
    call denite#custom#kind('file', 'default_action', 'split')

    " Add custom menus
    let s:menus = {}

    let s:menus.zsh = {
                \ 'description': 'Edit your import zsh configuration'
                \ }
    let s:menus.zsh.file_candidates = [
                \ ['zshrc', '~/.config/zsh/.zshrc'],
                \ ['zshenv', '~/.zshenv'],
                \ ]

    let s:menus.my_commands = {
                \ 'description': 'Example commands'
                \ }
    let s:menus.my_commands.command_candidates = [
                \ ['Split the window', 'vnew'],
                \ ['Open zsh menu', 'Denite menu:zsh'],
                \ ['Format code', 'FormatCode', 'go,python'],
                \ ]

    call denite#custom#var('menu', 'menus', s:menus)

    " Ag command on grep source
    call denite#custom#var('grep', 'command', ['dag'])
    call denite#custom#var('grep', 'default_opts',
                \ ['-i', '--vimgrep'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', [])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])

    " Ripgrep command on grep source
    call denite#custom#var('grep', 'command', ['drg'])
    call denite#custom#var('grep', 'default_opts',
                \ ['-i', '--vimgrep', '--no-heading'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])

    " Change ignore_globs
    call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
                \ [ '.git/', '.ropeproject/', '__pycache__/',
                \   'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])

endfunction

set completeopt-=preview
" echodoc
let g:echodoc#enable_at_startup = 1

function! s:is_dir(path) abort
    return !empty(a:path) && (isdirectory(a:path) ||
                \ (!empty($SYSTEMDRIVE) && isdirectory('/'.tolower($SYSTEMDRIVE[0]).a:path)))
endfunction

function! s:check_back_space() abort "{{{
    let l:col = col('.') - 1
    return !l:col || getline('.')[l:col - 1]  =~# '\s'
endfunction "}}}


function! s:get_my_cmp_fn(key) abort
    return get(s:my_cmps, a:key, "\<Nop>")
endfunction

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call <SID>get_my_cmp_fn('document_hover')()
    endif
endfunction

function! s:coc_hover() abort
    if (coc#rpc#ready())
        call CocActionAsync('doHover')
    else
        execute '!' . &keywordprg . ' ' . expand('<cword>')
    endif
endfunction

function! s:init_source_common() abort
    " Tab complete
    inoremap <silent><expr> <TAB>
                \ pumvisible() ? "\<C-n>" :
                \ <SID>check_back_space() ? "\<TAB>" :
                \ <SID>get_my_cmp_fn('complete')()
    inoremap <silent><expr> <S-TAB>
                \ pumvisible() ? "\<C-p>" :
                \ "\<S-TAB>"
    " <C-h>, <BS>: close popup and delete backword char.
    imap <BS> <Plug>(MyIMappingBS)
    " <CR>: close popup and save indent.
    " there seems issue with delimitMate and endwise tother.
    " a custom mapping with name '<Plug>*CR' seems a workaround
    imap <CR> <Plug>MyIMappingCR

    nnoremap <silent> K :call <SID>show_documentation()<CR>
endfunction


function! s:init_source_deoplete() abort
    " inoremap <expr> <C-h> deoplete#close_popup() . "\<C-h>"
    inoremap <expr> <C-g> deoplete#undo_completion()

    call deoplete#custom#option({
                \ 'auto_complete': v:true,
                \ 'ignore_case': v:true,
                \ 'smart_case': v:true,
                \ })
    if !has('nvim')
        call deoplete#custom#option('yarp', v:true)
    endif

    call deoplete#custom#var('omni', 'input_patterns', {
                \ 'ruby': ['[^. *\t]\.\w*', '[a-zA-Z_]\w*::'],
                \ 'java': '[^. *\t]\.\w*',
                \ 'php': '\w+|[^. \t]->\w*|\w+::\w*',
                \ 'javascript': '[^. *\t]\.\w*',
                \ 'typescript': '[^. *\t]\.\w*|\h\w*:',
                \ 'css': '[^. *\t]\.\w*',
                \ })

    call deoplete#custom#var('omni', 'function',{
                \ 'typescript': [ 'LanguageClient#complete' ],
                \ 'c': [ 'LanguageClient#complete'],
                \ 'cpp': [ 'LanguageClient#complete' ],
                \ 'rust': [ 'LanguageClient#complete'],
                \ 'php': [ 'LanguageClient#complete' ],
                \ })
    call deoplete#custom#var('terminal', 'require_same_tab', v:false)

    call deoplete#custom#option('ignore_sources', {
                \ '_': ['ale']
                \ })

    call deoplete#custom#source('look', {
                \ 'rank': 40,
                \ 'max_candidates': 15,
                \ })


    " deoplete-go
    let g:deoplete#sources#go#pointer = 1
    let g:deoplete#sources#go#builtin_objects = 1
    let g:deoplete#sources#go#unimported_packages = 1
endfunction

function! s:init_source_lc_neovim() abort
    let s:ccls_settings = {
                \ 'highlight': {'lsRanges': v:true},
                \ }
    let s:cquery_settings = {
                \ 'emitInactiveRegions': v:true,
                \ 'highlight': { 'enabled' : v:true},
                \ }
    let s:ccls_command = ['ccls', '-lint=' . json_encode(s:ccls_settings)]
    let s:cquery_command = ['cquery', '-lint=' . json_encode(s:cquery_settings)]
    let s:clangd_command = ['clangd', '-background-index']

    let g:LanguageClient_selectionUI = 'fzf'
    let g:LanguageClient_loadSettings = 1
    let g:LanguageClient_serverCommands = {
                \ 'rust': ['rustup', 'run', 'stable', 'rls'],
                \ 'typescript': ['javascript-typescript-stdio'],
                \ 'javascript': ['javascript-typescript-sdtio'],
                \ 'go': ['gopls'],
                \ 'yaml': ['yaml-language-server', '--stdio'],
                \ 'css': ['css-language-server', '--stdio'],
                \ 'sass': ['css-language-server', '--stdio'],
                \ 'less': ['css-language-server', '--stdio'],
                \ 'dockerfile': ['docker-langserver', '--stdio'],
                \ 'reason': ['ocaml-language-server', '--stdio'],
                \ 'ocaml': ['ocaml-language-server', '--stdio'],
                \ 'vue': ['vls'],
                \ 'lua': ['lua-lsp'],
                \ 'ruby': ['language_server-ruby'],
                \ 'c': s:clangd_command,
                \ 'cpp': s:clangd_command,
                \ 'vim': ['vim-language-server', '--stdio'],
                \ 'python': ['pyls'],
                \ 'dart': ['dart_language_server', '--force_trace_level=off'],
                \ 'haskell': ['hie', '--lsp'],
                \ 'sh': [ 'bash-language-server', 'start' ],
                \ }

    function! s:lsc_maps()
        nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<CR>
        nnoremap <buffer> <silent> gy :call LanguageClient#textDocument_typeDefinition()<CR>
        nnoremap <buffer> <silent> gi :call LanguageClient#textDocument_implementation()<CR>
        nnoremap <buffer> <silent> gr :call LanguageClient#textDocument_references()<CR>
        nnoremap <buffer> <silent> gs :call LanguageClient#textDocument_documentSymbol()<CR>
        nnoremap <buffer> gf :call LanguageClient#textDocument_formatting()<CR>

        " Rename - rn => rename
        noremap <leader>rn :call LanguageClient#textDocument_rename()<CR>

        " Rename - rc => rename camelCase
        noremap <leader>rc :call LanguageClient#textDocument_rename(
                    \ {'newName': Abolish.camelcase(expand('<cword>'))})<CR>

        " Rename - rs => rename snake_case
        noremap <leader>rs :call LanguageClient#textDocument_rename(
                    \ {'newName': Abolish.snakecase(expand('<cword>'))})<CR>

        " Rename - ru => rename UPPERCASE
        noremap <leader>ru :call LanguageClient#textDocument_rename(
                    \ {'newName': Abolish.uppercase(expand('<cword>'))})<CR>
    endfunction
    function! s:clangd_init()
        let g:neosnippet#enable_complete_done = 1
        let g:neosnippet#enable_completed_snippet = 1
    endfunction

    augroup gp_languageclent
        autocmd!
        autocmd FileType * call s:lsc_maps()
        autocmd FileType c,cpp call s:clangd_init()
    augroup END
endfunction

function! s:init_source_coc() abort
    let g:coc_global_extensions = ['coc-vimlsp',
                \ 'coc-tag', 'coc-syntax',
                \ 'coc-snippets', 'coc-prettier',
                \ 'coc-neosnippet', 'coc-lists',
                \ 'coc-highlight', 'coc-git',
                \ 'coc-explorer', 'coc-eslint',
                \ 'coc-dictionary', 'coc-yank',
                \ 'coc-yaml', 'coc-tsserver',
                \ 'coc-rust-analyzer', 'coc-rls',
                \ 'coc-python', 'coc-json',
                \ 'coc-html', 'coc-go',
                \ 'coc-css', 'coc-clangd',
                \ 'coc-docker', 'coc-fish',
                \ 'coc-java', 'coc-diagnostic',
                \ 'coc-bookmark', 'coc-imselect',
                \ 'coc-fzf-preview', 'coc-xml',
                \ 'coc-translator',
                \ ]

    function! s:coc_maps() abort
        " Use `[g` and `]g` to navigate diagnostics
        nmap <silent> [g <Plug>(coc-diagnostic-prev)
        nmap <silent> ]g <Plug>(coc-diagnostic-next)

        " Remap keys for gotos
        nmap <silent> gd <Plug>(coc-definition)
        nmap <silent> gy <Plug>(coc-type-definition)
        nmap <silent> gi <Plug>(coc-implementation)
        nmap <silent> gr <Plug>(coc-references)

        " Remap for rename current word
        nmap <leader>rn <Plug>(coc-rename)

        " Remap for format selected region
        xmap <leader>f  <Plug>(coc-format-selected)
        nmap <leader>f  <Plug>(coc-format-selected)

        " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
        xmap <leader>a  <Plug>(coc-codeaction-selected)
        nmap <leader>a  <Plug>(coc-codeaction-selected)

        " Remap for do codeAction of current line
        nmap <leader>ac  <Plug>(coc-codeaction)
        " Fix autofix problem of current line
        nmap <leader>qf  <Plug>(coc-fix-current)

        " Create mappings for function text object, requires document symbols feature of languageserver.
        xmap if <Plug>(coc-funcobj-i)
        xmap af <Plug>(coc-funcobj-a)
        omap if <Plug>(coc-funcobj-i)
        omap af <Plug>(coc-funcobj-a)

        " select selections ranges, needs server support, like: coc-tsserver, coc-python
        nmap <silent> <Leader>rs <Plug>(coc-range-select)
        xmap <silent> <Leader>rs <Plug>(coc-range-select)

        " Remap <C-f> and <C-b> for scroll float windows/popups.
        nnoremap <expr><C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
        nnoremap <expr><C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
        inoremap <expr><C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<Right>"
        inoremap <expr><C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<Left>"

        " translate
        nmap <Leader>k <Plug>(coc-translator-p)
        vmap <Leader>k <Plug>(coc-translator-pv)
    endfunction

    augroup gp_coc
        autocmd!

        autocmd User CocNvimInit call <SID>coc_maps()
        " Highlight symbol under cursor on CursorHold
        autocmd CursorHold * silent call CocActionAsync('highlight')
        " Setup formatexpr specified filetype(s).
        autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
        " Update signature help on jump placeholder
        autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end

    highlight CocHighlightText guibg=#5e5e61 gui=undercurl

    " Use `:Format` to format current buffer
    command! -nargs=0 CocFormat :call CocAction('format')

    " Use `:Fold` to fold current buffer
    command! -nargs=? CocFold :call CocAction('fold', <f-args>)

    " use `:OR` for organize import of current buffer
    command! -nargs=0 CocOR :call CocAction('runCommand', 'editor.action.organizeImport')

    " Add status line support, for integration with other plugin, checkout `:h coc-status`
    " set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

    " Using CocList
    " Show all diagnostics
    nnoremap <silent> <space>a :<C-u>CocList diagnostics<cr>
    " Manage extensions
    nnoremap <silent> <space>x :<C-u>CocList extensions<cr>
    " Show commands
    nnoremap <silent> <space>c :<C-u>CocList commands<cr>
    " Find symbol of current document
    nnoremap <silent> <space>o :<C-u>CocList outline<cr>
    " Search workspace symbols
    nnoremap <silent> <space>s :<C-u>CocList -I symbols<cr>
    " Do default action for next item.
    nnoremap <silent> <space>j :<C-u>CocNext<CR>
    " Do default action for previous item.
    nnoremap <silent> <space>k :<C-u>CocPrev<CR>
    " Resume latest coc list
    nnoremap <silent> <space>p :<C-u>CocListResume<CR>

    nnoremap <space>e :<C-u>CocCommand explorer<CR>

    " coc-snippets
    imap <c-l> <Plug>(coc-snippets-expand-jump)
    vmap <c-j> <Plug>(coc-snippets-select)
endfunction

" init completion source
let s:my_cmps = {}
function! s:init_cmp_source(src) abort

    " setup common variables
    if a:src ==? 'deoplete'
        " functions
        let s:my_cmps['complete'] = function('deoplete#manual_complete')
        let s:my_cmps['document_hover'] = function('LanguageClient#textDocument_hover')

        " mappings
        inoremap <expr> <Plug>(MyIMappingBS) pumvisible() ? deoplete#smart_close_popup() . "\<C-h>" : delimitMate#BS()
        imap <expr> <Plug>MyIMappingCR pumvisible() ? deoplete#close_popup() . "\<CR>" : "<Plug>delimitMateCR"

        " variables
        let g:deoplete#enable_at_startup = 1
        let g:LanguageClient_autoStart = 1
        let g:coc_start_at_startup = 0

        call s:init_source_deoplete()
        call s:init_source_lc_neovim()
    elseif a:src ==? 'coc'
        let s:my_cmps['complete'] = function('coc#refresh')
        let s:my_cmps['document_hover'] = function('<SID>coc_hover')

        inoremap <expr> <Plug>(MyIMappingBS) pumvisible() ? "\<C-h>" : delimitMate#BS()
        imap <expr> <Plug>MyIMappingCR pumvisible() ? "\<C-y>\<CR>" : "<Plug>delimitMateCR"

        let g:deoplete#enable_at_startup = 0
        let g:coc_start_at_startup = 1
        let g:LanguageClient_autoStart = 0
        call s:init_source_coc()
    endif

    call s:init_source_common()
endfunction
call s:init_cmp_source(g:my_cmp_source)

" Enable omni completion.
augroup omni_complete
    autocmd!
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    " neco-ghc
    autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
augroup END

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

" vim-sneak
map <Leader>s <Plug>Sneak_s
map <Leader>S <Plug>Sneak_S

inoremap <C-Space> <C-x><c-o>
if !has('gui_running')
    inoremap <C-@> <C-x><C-o>
endif

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

" quickrun
let g:quickrun_no_default_key_mappings = 1

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
