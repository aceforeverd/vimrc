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

if !has('nvim')
    let g:vimrc = s:home . '/vimrc'
else
    let g:vimrc = s:home . '/init.vim'
endif

let s:before_vimrc = s:home . '/before.vim'

if filereadable(s:before_vimrc)
    execute('source ' . s:before_vimrc)
endif

let &runtimepath = &runtimepath . ',' . s:home
call aceforeverd#settings#my_init()

" global leader
let g:mapleader = ','
" local leader
let g:maplocalleader = '\'


" =============================================================== "
" Plugin Manager, in order
" 1. minpac
" 2. lazy.nvim
" =============================================================== "

call aceforeverd#plugin#setup()

" =================== extra conf ============================= "

filetype plugin on
filetype indent on

let $LANG='en'
set langmenu=en

" Ignore compiled files
set wildignore=*.o,*~,*.pyc,*.gch
if has('win16') || has('win32')
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store,*/node_modules/*
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
set dictionary+=/usr/share/dict/words
set spelllang=en_us,en,cjk

set showcmd
" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set signcolumn=yes

" enable italic for vim
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"

set timeoutlen=500
set updatetime=250

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
" use space for tab
set expandtab
set smarttab

" replace by vim-sleuth
" set shiftwidth=4
" set tabstop=4

set linebreak
set textwidth=500

set autoindent "Auto indent
set smartindent "Smart indent
set wrap "Wrap lines

" magic script from vim/neovim terminal
let $PATH .= ":" . s:home . '/bin'

if has('patch-8.1.0360')
    set diffopt+=internal,algorithm:patience
endif

" map <silent> <leader><cr> :noh<cr>
nnoremap <leader>tn :tabnew<cr>
nnoremap <leader>to :tabonly<cr>
nnoremap <leader>tc :tabclose<cr>
nnoremap <leader>tm :tabmove<cr>
nnoremap <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/
" open current window in new tab, same as maximize current window
" <c-w>c to close the tab
nnoremap <leader>to :tab split<cr>
nnoremap ]v :tabnext<cr>
nnoremap [v :tabprevious<cr>

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

if has('nvim-0.7.0')
    set laststatus=3
else
    set laststatus=2
endif

set mouse=a

if !has('nvim') && &term =~? '256color$'
    " Cursor shapes, use a blinking upright bar cursor in Insert mode, a blinking block in normal
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
    " if exists('$TMUX')
    "     let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
    "     let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    " endif
endif

set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
		\,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
		\,sm:block-blinkwait175-blinkoff150-blinkon175

" Make VIM remember position in file after reopen
augroup gp_cursor_location
    " this one is which you're most likely to use?
   autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END

" guifont only works on GUIs
if has('mac') || has('macunix')
    set guifont=JetBrainsMonoNerdFontComplete-Regular:h13,JetBrainsMono\ Nerd\ Font:h13,FiraCodeNerdFontComplete-Regular:h13,FiraCode\ Nerd\ Font:h13,SauceCodeProNerdFontComplete-Regular:h13
elseif has('win16') || has('win32')
    set guifont=Hack:h14,Source\ Code\ Pro:h12,Bitstream\ Vera\ Sans\ Mono:h11
elseif has('gui_gtk2')
    set guifont=Hack\ 14,Source\ Code\ Pro\ 12,Bitstream\ Vera\ Sans\ Mono\ 11
elseif has('linux')
    set guifont=FiraCode\ Nerd\ Font\ 12,JetBrainsMono\ Nerd\ Font\ 12,Fira\ Code\ 12,JetBrains\ Mono\ 12
elseif has('unix')
    set guifont=Source\ Code\ Pro\ Medium\ 11
endif

try
    " the undo dir may need create manually
    if has('nvim-0.5')
        let &undodir= s:common_path . '/undodir-0.5/'
    else
        let &undodir= s:common_path . '/undodir/'
    endif

    set undofile
catch
endtry

" scroll window and cursor together, cursor location compared to current window not change
nnoremap <M-j> <C-e>j
nnoremap <M-k> <C-y>k

" basic completion settings
set completeopt-=preview
set completeopt+=menuone
set completeopt+=noselect
set mousemodel=popup_setpos

set shortmess+=c
" give the file info when editing a file
set shortmess-=F
" only apply to vim
set shortmess-=S

call aceforeverd#settings#basic_color()
" setup sonokai
augroup gp_colorscheme
    autocmd!
    autocmd ColorSchemePre sonokai call aceforeverd#settings#sonokai_pre()
    autocmd ColorScheme * call aceforeverd#settings#hl_groups()
augroup END

colorscheme sonokai

if has('nvim-0.5')
    lua require('aceforeverd').setup()
endif

let s:after_vimrc = s:home . '/after.vim'
if filereadable(s:after_vimrc)
    execute('source ' . s:after_vimrc)
endif
