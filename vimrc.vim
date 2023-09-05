" lightweight vim configuration

set nocompatible

let s:home = expand('<sfile>:p:h')
let s:common_path = s:home . '/bundle'
let s:common_pkg = s:common_path . '/pkgs'

if !has('nvim')
    let g:vimrc = s:home . '/vimrc'
else
    let g:vimrc = s:home . '/init.vim'
endif

nnoremap <Leader>ec :execute 'edit' g:vimrc<CR>

if empty(glob(s:home. '/autoload/plug.vim'))
    silent execute '!curl -fLo '.s:home.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(s:common_pkg)

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-scriptease'

Plug 'Shougo/neco-syntax'
Plug 'Shougo/context_filetype.vim'
Plug 'Shougo/neco-vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-sneak'
Plug 'rhysd/clever-f.vim'

Plug 'sainnhe/everforest'

Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'honza/vim-snippets'
Plug 'raimondi/delimitmate'

Plug 'mhinz/vim-startify'
Plug 'rhysd/committia.vim'
Plug 'ojroques/vim-oscyank'

Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_modules = [ 'ctags' ]

Plug 'airblade/vim-rooter'
let g:rooter_cd_cmd = 'lcd'

Plug 'airblade/vim-gitgutter'
omap ih <Plug>(GitGutterTextObjectInnerPending)
omap ah <Plug>(GitGutterTextObjectOuterPending)
xmap ih <Plug>(GitGutterTextObjectInnerVisual)
xmap ah <Plug>(GitGutterTextObjectOuterVisual)
if has('nvim-0.4.0')
    let g:gitgutter_highlight_linenrs = 1
endif
let g:gitgutter_close_preview_on_escape = 1
if has('nvim-0.4.0') || has('popupwin')
    let g:gitgutter_preview_win_floating = 1
endif
let g:gitgutter_max_signs = 1000

Plug 'itchyny/lightline.vim'

function! GitStatus()
    let [a,m,r] = GitGutterGetHunkSummary()
    let s:diff_str = ''
    if a != 0
        let s:diff_str ..= ' +' .. a
    endif
    if m != 0
        let s:diff_str ..= ' ~' .. m
    endif
    if r != 0
        let s:diff_str ..= ' -' .. r
    endif
    return s:diff_str
endfunction
function! LspStatus() abort
    return lsp#get_server_status()
endfunction
function! LspDiagnosticCount() abort
    let s:counts = lsp#get_buffer_diagnostics_counts()
    let s:d = ''
    if s:counts['error'] != 0
        let s:d ..= '  ' .. s:counts['error']
    endif
    if s:counts['warning'] != 0
        let s:d ..= '  ' .. s:counts['warning']
    endif
    if s:counts['information'] != 0
        let s:d ..= '  ' .. s:counts['information']
    endif
    if s:counts['hint'] != 0
        let s:d ..= ' ' .. s:counts['hint']
    endif
    return s:d
endfunction
function! s:lightline_setup() abort
    let g:lightline = {
      \ 'colorscheme': 'deus',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste', 'git_branch' ],
      \             [ 'readonly', 'modified', 'git_diff', 'diagnostic_count' ],
      \             [ 'lsp_status' ]
      \    ],
      \   'right': [
      \     [ 'lineinfo', 'total_line', 'percent' ],
      \     [ 'fileencoding', 'fileformat', 'spell' ],
      \     [ 'filetype' ]
      \   ]
      \ },
      \ 'inactive': {
      \   'left': [ [ 'filename' ] ],
      \   'right': [ [ 'lineinfo' ], [ 'percent' ] ]
      \ },
      \ 'tabline': {},
      \ 'component': {
      \   'total_line': '%L',
      \  },
      \ 'component_function': {
      \   'lsp_status': 'LspStatus',
      \   'diagnostic_count': 'LspDiagnosticCount',
      \   'git_branch': 'FugitiveHead',
      \   'git_diff': 'GitStatus',
      \ }
      \ }
endfunction
call s:lightline_setup()

Plug 'wincent/terminus'

if has('timers')
    Plug 'dense-analysis/ale'

    Plug 'prabirshrestha/asyncomplete.vim'
    Plug 'prabirshrestha/asyncomplete-lsp.vim'
    Plug 'prabirshrestha/asyncomplete-neosnippet.vim'
    Plug 'prabirshrestha/asyncomplete-buffer.vim'
    Plug 'prabirshrestha/asyncomplete-file.vim'
    Plug 'prabirshrestha/asyncomplete-necosyntax.vim'
    Plug 'prabirshrestha/asyncomplete-necovim.vim'
    Plug 'htlsne/asyncomplete-look'

    " Hack: need this to work well with endwise
    imap <expr> <Plug>(MyICrMap) pumvisible() ? asyncomplete#close_popup() . "<Plug>delimitMateCR" : "<Plug>delimitMateCR"
    imap <CR> <Plug>(MyICrMap)
endif

Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

Plug 'tpope/vim-endwise'

let g:lsp_diagnostics_float_cursor = 1
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gD <plug>(lsp-declaration)
    nmap <buffer> <leader>df <plug>(lsp-peek-definition)
    nmap <buffer> <space>s <plug>(lsp-document-symbol-search)
    nmap <buffer> <space>S <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> <leader>di <plug>(lsp-peek-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nmap <buffer> <leader>ca <Plug>(lsp-code-action)
    nmap <buffer> <space>q <Plug>(lsp-document-diagnostics)
    nmap <buffer> <space>a :LspDocumentDiagnostics --buffers=*<cr>
    xmap <buffer> <cr> <Plug>(lsp-document-range-format)
    inoremap <buffer> <expr><c-f> lsp#scroll(+4)
    inoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
endfunction

augroup gp_lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
    autocmd User asyncomplete_setup call s:asyncomplete_setup_sources()
augroup END

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction
function! s:asyncomplete_setup_sources() abort
    set completeopt-=preview
    set completeopt+=menuone,noselect

    let g:asyncomplete_min_chars = 1

    inoremap <silent> <expr> <TAB>
                \ pumvisible() ? "\<C-n>" :
                \ <SID>check_back_space() ? "\<TAB>" :
                \ asyncomplete#force_refresh()

    inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    inoremap <expr> <BS> pumvisible() ? asyncomplete#close_popup() . "\<bs>" : delimitMate#BS()
    inoremap <expr> <c-h> pumvisible() ? asyncomplete#cancel_popup() . "\<c-h>" : "\<c-h>"

    call asyncomplete#register_source(asyncomplete#sources#neosnippet#get_source_options({
                \ 'name': 'neosnippet',
                \ 'allowlist': ['*'],
                \ 'completor': function('asyncomplete#sources#neosnippet#completor'),
                \ }))

    call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
                \ 'name': 'buffer',
                \ 'allowlist': ['*'],
                \ 'completor': function('asyncomplete#sources#buffer#completor'),
                \ 'config': {
                \    'max_buffer_size': 5000000,
                \  },
                \ }))
    call asyncomplete#register_source({
                \ 'name': 'look',
                \ 'allowlist': ['*'],
                \ 'completor': function('asyncomplete#sources#look#completor'),
                \ })
    call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
                \ 'name': 'file',
                \ 'allowlist': ['*'],
                \ 'priority': 10,
                \ 'completor': function('asyncomplete#sources#file#completor')
                \ }))
    call asyncomplete#register_source(asyncomplete#sources#necosyntax#get_source_options({
                \ 'name': 'necosyntax',
                \ 'allowlist': ['*'],
                \ 'completor': function('asyncomplete#sources#necosyntax#completor'),
                \ }))
    call asyncomplete#register_source(asyncomplete#sources#necovim#get_source_options({
                \ 'name': 'necovim',
                \ 'allowlist': ['vim'],
                \ 'completor': function('asyncomplete#sources#necovim#completor'),
                \ }))
endfunction

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
set shortmess+=c
set shortmess-=S

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
nnoremap <leader>l :nohlsearch<cr>

set incsearch
set lazyredraw
set magic
set showmatch
set matchtime=2
set history=1000
set wildmenu
set backspace=indent,eol,start
set cursorline
set cursorcolumn

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set timeoutlen=500
set updatetime=500

set guifont=FiraCodeNerdFontComplete-Regular:h13

" enable italic for vim
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"

set background=dark

if !has('termguicolors')
    echomsg 'termguicolors not available'
elseif has('nvim')
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
    set termguicolors
else
    if empty($TMUX) && ($TERM=~#'xterm-256color' || $TERM=~#'screen-256color' || $TERM=~#'xterm-color' || $TERM =~# 'xterm-kitty' || has('gui_running'))
        set termguicolors
    endif
endif

augroup gp_vim_lsp_color
    autocmd!
    autocmd! ColorScheme * highlight lspReference cterm=bold gui=bold guibg=#5e5e5e
augroup END

colorscheme everforest

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

set tabstop=4

set linebreak
set textwidth=500

set autoindent "Auto indent
set smartindent "Smart indent
set wrap "Wrap lines
set showcmd

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
autocmd TabLeave * let g:lasttab = tabpagenr()

nnoremap <Leader>ec :execute 'edit' g:vimrc<CR>

" Specify the behavior when switching between buffers
try
    set switchbuf=useopen,usetab,newtab
    set showtabline=2
catch
endtry

set laststatus=2

nnoremap <C-L> <Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>

" netrw
augroup gp_netrw_cs
    autocmd!
    autocmd FileType netrw call s:netrw_custom()
augroup END
function! s:netrw_custom() abort
    highlight netrwSuffixes ctermfg=250 ctermbg=235 guifg=#e4e3e1 guibg=#312c2b
    setlocal bufhidden=wipe
    nnoremap <buffer> gq <Cmd>Rexplore<cr>
endfunction

" Cursor shapes, use a blinking upright bar cursor in Insert mode, a blinking block in normal
let g:TerminusCursorShape = 0
if !has('nvim') && &term =~? '256color$'
    " when start insert mode - blinking vertical bar
    let &t_SI = "\<Esc>[5 q"
    " when end insert/replace mode(common) - blinking block
    let &t_EI = "\<Esc>[1 q"
    " when start replace mode
    if v:version > 800
        let &t_SR = "\<Esc>[4 q"
    endif

    augroup cursor_shape
        autocmd!
        autocmd VimLeave * let &t_te .= "\<Esc>[3 q"
        autocmd VimLeave * set guicursor=a:hor25-blinkon300
    augroup END
endif

" if exists('$TMUX')
"     let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
"     let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
" endif

set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
            \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
            \,sm:block-blinkwait175-blinkoff150-blinkon175

" Make VIM remember position in file after reopen
if has('autocmd')
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

try
    let &undodir = s:common_path . '/undodir/'
    set undofile
catch
endtry

" fzf
nnoremap <c-p> :FZF --info=inline<CR>
function! s:build_quickfix_list(lines)
    call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
    copen
    cc
endfunction
let g:fzf_action = {
            \ 'ctrl-l': function('s:build_quickfix_list'),
            \ 'ctrl-a': 'tab split',
            \ 'ctrl-x': 'split',
            \ 'ctrl-v': 'vsplit' }
let g:fzf_layout = {
      \ 'window': { 'width': 0.8, 'height': 0.8 }}

" fzf-vim
command! Helptags :call fzf#vim#helptags(<bang>0)
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

nnoremap <space>b :Buffers<CR>
nnoremap <space>r :Rg<CR>
nnoremap <Space>f :Files<CR>
nnoremap <space>c :Commands<CR>

command! -bang -nargs=* GGrep
            \ call fzf#vim#grep(
            \   'git grep --line-number -- '.shellescape(<q-args>), 0,
            \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

if executable('rg')
    set grepprg=rg\ --vimgrep\ --smart-case\ --no-heading\ --no-config
endif

" neosnippet
imap <leader>e <Plug>(neosnippet_expand_or_jump)
smap <leader>e <Plug>(neosnippet_expand_or_jump)
xmap <leader>e <Plug>(neosnippet_expand_target)
let g:neosnippet#enable_snipmate_compatibility = 1

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
let g:startify_fortune_use_unicode = 1
let g:startify_session_sort = 1
let g:startify_relative_path = 1

" Ale
" let g:ale_linters = {}
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_sign_error = '✖'
let g:ale_sign_warning = '⚠'
let g:ale_sign_info = 'ℹ'
nmap <silent> <c-k> <Plug>(ale_previous_wrap)
nmap <silent> <c-j> <Plug>(ale_next_wrap)
let g:ale_disable_lsp = 1

" vim-markdown
let g:markdown_fenced_languages = ['html', 'json', 'javascript', 'c', 'bash=sh']

inoremap <C-Space> <C-x><c-o>
if !has('gui_running')
    inoremap <C-@> <C-x><C-o>
endif

function! s:syn_query() abort
    if has('nvim')
        execute 'Inspect'
    else
        execute "normal \<Plug>ScripteaseSynnames"
    endif
endfunction

nnoremap <silent> zS :<c-u>call s:syn_query()<cr>

let g:sneak#label = 1
let g:sneak#s_next = 1 " go the next/previous match by s/S, same as clever-f
nmap <silent> <expr> <tab> sneak#is_sneaking() ? '<Plug>Sneak_;' : '<TAB>'
nmap <silent> <expr> <s-tab> sneak#is_sneaking() ? '<Plug>Sneak_,' : '<S-TAB>'
