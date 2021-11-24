" lightweight vim configuration

set nocompatible

if !has('nvim')
    let g:vimrc = $HOME . '/.vimrc'
else
    let g:vimrc = $HOME . '/.config/nvim/init.vim'
endif

call plug#begin('~/.vim-commons/pkgs')

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'

Plug 'Shougo/neco-syntax'
Plug 'Shougo/context_filetype.vim'
Plug 'Shougo/neco-vim'
Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'dense-analysis/ale'

Plug 'Shougo/echodoc.vim'
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/neoinclude.vim'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'Raimondi/delimitMate'

Plug 'mhinz/vim-startify'
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/lightline.vim'

Plug 'wincent/terminus'

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

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


set background=dark
if has('nvim')
    let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
endif
if has('termguicolors') && (has('nvim') || empty($TMUX))
    set termguicolors
endif
colorscheme onedark

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

nnoremap <Leader>ec :execute 'edit' g:vimrc<CR>

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

try
    set undodir=$HOME/.vim/temp_dirs/undodir/
    set undofile
catch
endtry

autocmd BufRead,BufNewFile *.verilog,*.vlg setlocal filetype=verilog

" fzf
nnoremap <c-p> :FZF<CR>
let g:fzf_action = {
      \ 'ctrl-a': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }

" fzf-vim
command! Helptags :call fzf#vim#helptags(<bang>0)

if executable('rg')
    set grepprg=rg\ --vimgrep
endif

" neosnippet
imap <Leader>e <Plug>(neosnippet_expand_or_jump)
smap <Leader>e <Plug>(neosnippet_expand_or_jump)
xmap <Leader>e <Plug>(neosnippet_expand_target)
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

" vim-gitgutter
let g:gitgutter_max_signs = 1000

" Ale
let g:ale_linters = {
            \ 'go': ['go build', 'gofmt', 'go vet', 'golint', 'gotype'],
            \ 'rust': ['cargo', 'rls', 'rustc'],
            \ }
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_sign_error = '✖'
let g:ale_sign_warning = '⚠'
let g:ale_sign_info = 'ℹ'
nmap <silent> <c-k> <Plug>(ale_previous_wrap)
nmap <silent> <c-j> <Plug>(ale_next_wrap)

" vim-markdown
let g:markdown_fenced_languages = ['html', 'json', 'javascript', 'c', 'bash=sh']


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

" Tab complete
inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ deoplete#mappings#manual_complete()
inoremap <expr> <S-TAB>
            \ pumvisible() ? "\<C-p>" :
            \ "\<S-TAB>"
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

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
            \ 'c': [ 'ClangComplete', 'LanguageClient#complete' ],
            \ 'cpp': [ 'ClangComplete', 'LanguageClient#complete' ],
            \ 'rust': [ 'racer#RacerComplete', 'LanguageClient#complete'],
            \ 'php': [ 'phpactor#Complete', 'LanguageClient#complete' ],
            \ })

" source rank
call deoplete#custom#source('look', 'rank', 70)

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


inoremap <C-Space> <C-x><c-o>
if !has('gui_running')
    inoremap <C-@> <C-x><C-o>
endif

