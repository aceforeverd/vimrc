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
set dictionary+=/usr/share/dict/words
set spelllang=en_us,en,cjk
" set spell

set showcmd
" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=

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

if has('patch-8.1.0360')
    set diffopt+=internal,algorithm:patience
endif

" terminal mode mapping
function! s:terminal_mapping() abort
    let g:floaterm_width = 0.9
    let g:floaterm_height = 0.9
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
    tnoremap <expr> <C-q> '<C-\><C-N>"'.nr2char(getchar()).'pi'
endfunction
if has('nvim') || has('terminal')
    call s:terminal_mapping()
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

" Cursor shapes, use a blinking upright bar cursor in Insert mode, a blinking block in normal
if &term ==? 'xterm-256color' || &term ==? 'screen-256color'
    " when start insert mode - blinking vertical bar
    let &t_SI = "\<Esc>[5 q"
    " when end insert/replace mode(common) - blinking block
    let &t_EI = "\<Esc>[1 q"
    " when start replace mode
    let &t_SR = "\<Esc>[4 q"
endif

set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
		\,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
		\,sm:block-blinkwait175-blinkoff150-blinkon175
augroup cursor_shape
    autocmd!
    autocmd VimLeave * let &t_te .= "\<Esc>[3 q"
    autocmd VimLeave * set guicursor=a:hor25-blinkon300
augroup END

" if exists('$TMUX')
"     let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
"     let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
" endif

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

" ====================================================
" =       start plugin configs
" ====================================================

" suda.vim
command! SudaWrite exe 'w suda://%'
command! SudaRead  exe 'e suda://%'

augroup gp_filetype
    autocmd!
    autocmd FileType verilog,verilog_systemverilog setlocal nosmartindent
    autocmd FileType javascript setlocal nocindent
augroup END

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
      \ 'window': { 'width': 0.9, 'height': 0.8 }}
let g:fzf_history_dir = '~/.local/share/fzf-history'

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
nnoremap <Space>r :Rg<CR>
if !has('nvim')
    nnoremap <Space>c :Commands<CR>
    nnoremap <Space>f :Files<CR>
    nnoremap <Space>b :Buffers<CR>
endif

command! -bang -nargs=* GGrep
            \ call fzf#vim#grep(
            \   'git grep --line-number -- '.shellescape(<q-args>), 0,
            \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

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
    set grepprg=rg\ --vimgrep\ --smart-case
endif

" editorconfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://*']


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

" vim-markdown
let g:markdown_fenced_languages = ['html', 'json', 'javascript', 'c', 'bash=sh', 'vim', 'help']
" markdown-preview
let g:mkdp_auto_close = 0

" markdown local settings
augroup gp_markdown
  autocmd!
  autocmd FileType markdown,rmd,pandoc.markdown map <buffer> <leader>mp <Plug>MarkdownPreview
  autocmd FileType markdown,rmd,pandoc.markdown,gitcommit setlocal spell
augroup END

" easy-align
vmap <Leader>a <Plug>(EasyAlign)
nmap <Leader>a <Plug>(EasyAlign)

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

" vim-sneak
let g:sneak#label = 1
map sk <Plug>Sneak_s
map sK <Plug>Sneak_S

" vim-header
let g:header_auto_add_header = 0
let g:header_field_timestamp = 0
let g:header_field_modified_timestamp = 0
let g:header_field_author = g:my_name
let g:header_field_author_email = g:my_email
let g:header_field_modified_by = 0
let g:header_field_license_id = 'GPL'

" tmux navigator
let g:tmux_navigator_no_mappings = 1

augroup gp_lookup
    autocmd!
    autocmd FileType vim,lua,tmux nnoremap <buffer> gs :call plugin_browse#try_open()<CR>
    autocmd FileType vim,lua,help nnoremap <buffer> <leader>gh :call aceforeverd#completion#help()<cr>
augroup END

" open-browser
command! OpenB execute 'normal <Plug>(openbrowser-open)'
vmap <Leader>os <Plug>(openbrowser-search)

" ferret
let g:FerretMap = 0

" vim-better-whitespace
let g:better_whitespace_operator = ''
let g:current_line_whitespace_disabled_soft = 1

" neoformat
let g:neoformat_enabled_lua = ['luaformat', 'stylua']

if aceforeverd#util#has_float()
    " matchup
    if has('nvim-0.5.0')
        " disable due to conflicts with ts-context.nvim
        let g:matchup_matchparen_offscreen = {}
    else
        let g:matchup_matchparen_offscreen = {'method': 'popup', 'scrolloff': 1}
    endif
endif
let g:matchup_matchparen_deferred = 1

" vim-translator
let g:translator_default_engines = ['google']
let g:translator_history_enable = 1
nmap <silent> <Leader>tr <Plug>TranslateW
vmap <silent> <Leader>tr <Plug>TranslateWV

" vim-cmake
let g:cmake_generate_options = [ '-G Ninja' ]
let g:cmake_link_compile_commands = 1

" vimspector
let g:vimspector_enable_mappings = 'HUMAN'

nnoremap <silent> <leader>cs :<c-u>call aceforeverd#util#syn_query()<cr>
nnoremap <silent> <leader>cv :<c-u>call aceforeverd#util#syn_query_verbose()<cr>

" switch.vim
let g:switch_mapping = '<space>x'

" vim gtfo
nnoremap <expr> goo 'go'

" vim-sandwich
nnoremap ss s

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

if g:my_cmp_source !=? 'nvim_lsp'
   call aceforeverd#completion#init_cmp_source(g:my_cmp_source)
endif

let s:after_vimrc = s:home . '/after.vim'
if filereadable(s:after_vimrc)
    execute('source ' . s:after_vimrc)
endif
