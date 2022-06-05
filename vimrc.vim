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

let &runtimepath = &runtimepath . ',' . s:home
call aceforeverd#settings#my_init()

" download vim-plug
if empty(glob(s:home. '/autoload/plug.vim'))
    echomsg 'automatically downloading vim-plug ...'
    execute '!curl -fLo '.s:home.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    echomsg 'installed vim-plug into ' . s:home . '/autoload/plug.vim'
    augroup gp_vim_plug_bootstrap
       autocmd!
       autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    augroup END
endif

" download dein
let s:dein_path = s:dein_repo . '/repos/github.com/Shougo/dein.vim'
if empty(glob(s:dein_path))
    echomsg 'automatically downloading dein.vim ...'
    execute '!git clone https https://github.com/Shougo/dein.vim.git ' . s:dein_path
    echomsg 'installed dein.vim into ' . s:dein_path
endif
let &runtimepath = &runtimepath . ',' . s:dein_path

" global leader
let g:mapleader = ','
" local leader
let g:maplocalleader = '\'

" vim plug
" ============================================================================================

call plug#begin(s:common_pkg) "{{{

if !has('nvim-0.5.0')
   " vim or nvim <= 0.4.0 use airline & gitgutter
   " nvim 0.5.0 or later use the combination of
   "   feline.nvim, gitsigns and bufferline.nvim
    Plug 'vim-airline/vim-airline'
    let g:airline#extensions#tabline#enabled = 1
    let g:airline_detect_modified=1
    let g:airline_detect_paste=1
    let g:airline_theme='sonokai'
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

if g:my_cmp_source ==? 'coc'
   " nvim 0.6.0 or later use built-in lsp
   Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
   Plug 'antoinemadec/coc-fzf'
   Plug 'neoclide/coc-neco'

   " coc-fzf
   let g:coc_fzf_preview = 'up:80%'
endif

if g:my_autopair ==? 'delimitmate'
   Plug 'raimondi/delimitmate'
   "" see help delimitMateExpansion
   let g:delimitMate_expand_cr = 2
   let g:delimitMate_expand_space = 1
   let g:delimitMate_balance_matchpairs = 1
   augroup delimitMateCustom
      autocmd!
      autocmd FileType html,xhtml,xml let b:delimitMate_matchpairs = "(:),[:],{:}"
      autocmd FileType rust let b:delimitMate_quotes = "\" `"
   augroup END
elseif g:my_autopair ==? 'lexima'
   Plug 'cohama/lexima.vim'
endif

call plug#end() "}}}

call aceforeverd#plugin#minpac()

let g:dein#install_process_timeout = 180
let g:dein#install_process_type = 'tabline'

" polyglot
let g:polyglot_disabled = ['sensible', 'autoindent', 'go']
let g:vim_json_syntax_conceal = 1

if dein#load_state(s:dein_repo)
    call dein#begin(s:dein_repo)

    call dein#add(s:dein_path)

    if !has('nvim')
        " optional plugins for vim
        call dein#add('roxma/nvim-yarp')
        call dein#add('roxma/vim-hug-neovim-rpc')
        call dein#add('gelguy/wilder.nvim', {
                    \ 'hook_post_source': 'call aceforeverd#completion#wider()'
                    \ })
        call dein#add('wellle/tmux-complete.vim', {
                    \ 'hook_source': 'let g:tmuxcomplete#trigger = ""'
                    \ })
    endif

    if g:my_cmp_source !=? 'nvim_lsp'
        call dein#add('Shougo/context_filetype.vim')
        call dein#add('Shougo/neco-syntax')
        call dein#add('Shougo/neco-vim')
        call dein#add('Shougo/echodoc.vim')
    endif

    call dein#add('voldikss/vim-floaterm')

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
    call dein#add('tpope/vim-sleuth')
    call dein#add('tpope/vim-apathy')
    call dein#add('tpope/vim-characterize')

    call dein#add('lambdalisue/suda.vim')

    " snippets
    call dein#add('honza/vim-snippets')

    " interface
    call dein#add('sheerun/vim-polyglot', {'merged': 0})
    call dein#add('chrisbra/unicode.vim', {'merged': 0})
    call dein#add('ryanoasis/vim-devicons')
    call dein#add('mhinz/vim-startify')
    call dein#add('ntpeters/vim-better-whitespace')
    call dein#add('liuchengxu/vista.vim')
    call dein#add('wincent/terminus')
    call dein#add('vifm/vifm.vim')
    call dein#add('sainnhe/sonokai', {
                \ 'merged': 0,
                \ 'hook_post_source': 'colorscheme sonokai'})
    call dein#add('justinmk/vim-gtfo')

    " motion
    call dein#add('rhysd/clever-f.vim')
    call dein#add('justinmk/vim-sneak')
    call dein#add('andymass/vim-matchup')
    " Tools
    call dein#add('editorconfig/editorconfig-vim')
    call dein#add('will133/vim-dirdiff')
    call dein#add('dstein64/vim-startuptime')
    call dein#add('jsfaint/gen_tags.vim')
    call dein#add('AndrewRadev/bufferize.vim')
    call dein#add('mg979/vim-visual-multi')
    call dein#add('tyru/open-browser.vim')
    call dein#add('wincent/ferret')
    call dein#add('ojroques/vim-oscyank')

    call dein#add('alpertuna/vim-header')
    call dein#add('antoyo/vim-licenses')
    " code format
    call dein#add('sbdchd/neoformat')
    call dein#add('junegunn/vim-easy-align')
    " run/debug/test
    call dein#add('vim-test/vim-test')
    call dein#add('skywind3000/asyncrun.vim')
    call dein#add('skywind3000/asynctasks.vim')
    call dein#add('jpalardy/vim-slime')
    call dein#add('preservim/vimux')

    " VCS
    call dein#add('tpope/vim-fugitive')
    call dein#add('junegunn/gv.vim')
    call dein#add('rhysd/committia.vim')

    " search
    call dein#add('junegunn/fzf', {
                \ 'path': $HOME . '/.fzf',
                \ 'build': './install --all',
                \ 'merged': 0
                \ })
    call dein#add('junegunn/fzf.vim')

    call dein#add('mbbill/undotree')
    call dein#add('jamessan/vim-gnupg')

    call dein#add('tomtom/tcomment_vim')
    call dein#add('chrisbra/recover.vim')
    " text object manipulate
    call dein#add('AndrewRadev/splitjoin.vim')
    call dein#add('AndrewRadev/sideways.vim')
    call dein#add('AndrewRadev/tagalong.vim')
    call dein#add('AndrewRadev/switch.vim')
    call dein#add('chrisbra/NrrwRgn')
    call dein#add('machakann/vim-sandwich')
    " Debug
    call dein#add('puremourning/vimspector')

    " Typescript
    call dein#add('HerringtonDarkholme/yats.vim')

    " Haskell
    call dein#add('neovimhaskell/haskell-vim')
    " vimL
    call dein#add('mhinz/vim-lookup')

    call dein#add('tweekmonster/exception.vim')
    call dein#add('tweekmonster/helpful.vim')
    " markdown
    call dein#add('mzlogin/vim-markdown-toc')
    call dein#add('iamcco/markdown-preview.nvim', {
                \ 'on_ft': ['markdown', 'pandoc.markdown', 'rmd'],
                \ 'build': 'cd app && yarn install' })

    call dein#add('rust-lang/rust.vim')
    call dein#add('vim-ruby/vim-ruby')
    " Tmux
    call dein#add('tmux-plugins/vim-tmux')
    call dein#add('christoomey/vim-tmux-navigator')

    call dein#add('kovisoft/slimv', {'merged': 0})
    " gentoo
    call dein#add('gentoo/gentoo-syntax')

    call dein#add('chrisbra/csv.vim')

    call dein#add('cdelledonne/vim-cmake')

    call dein#add('aceforeverd/vim-translator', {'rev': 'dev', 'merged': 0})

    call dein#end()
    call dein#save_state()
endif

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

" scroll window and cursor together, cursor location compared to current window not change
nnoremap <M-j> <C-e>j
nnoremap <M-k> <C-y>k

" ====================================================
" =       start plugin configs
" ====================================================

" dein.vim
function! s:delete_path(key, value) abort
    call delete(a:value, 'rf')
    echomsg 'DeinClean: deleted ' . a:value
    return a:value
endfunction
command! DeinInstall exe 'call dein#install()'
command! DeinUpdate exe 'call dein#update()'
command! DeinClean exe 'echo map(dein#check_clean(), function("<SID>delete_path"))'
command! DeinRecache exe 'call dein#recache_runtimepath() | echo "Done"'
command! DeinLog exe 'echo dein#get_log()'

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

" vim-license
let g:licenses_copyright_holders_name = g:my_name . ' <' . g:my_email . '>'

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

" gen_tags.vim
let g:gen_tags#ctags_auto_update = 0
let g:gen_tags#gtags_auto_update = 0
let g:gen_tags#ctags_opts = '--links=no'
let g:gen_tags#gtags_opts = '--skip-symlink'
if !executable('gtags')
    let g:loaded_gentags#gtags = 1
endif
if !executable('ctags')
    let g:loaded_gentags#ctags = 1
endif

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

if has('nvim-0.5')
    lua require('aceforeverd')
endif

if g:my_cmp_source !=? 'nvim_lsp'
   call aceforeverd#completion#init_cmp_source(g:my_cmp_source)
endif

" there is autocmd for ColorScheme in lua & init_cmp_source hook for sonokai
call dein#call_hook('source')
call dein#call_hook('post_source')

let s:after_vimrc = s:home . '/after.vim'
if filereadable(s:after_vimrc)
    execute('source ' . s:after_vimrc)
endif
