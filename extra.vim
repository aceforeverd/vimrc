" File              : Dropbox/Linux/ArchVimrc/extra.vim
" Date              : 03.10.2017
" Last Modified Date: 03.10.2017
set history=500

filetype plugin on
filetype indent on

set autoread

" global leader
let g:mapleader = ','
" local leader
let g:maplocalleader = '\'

set scrolloff=3

let $LANG='en'
set langmenu=en

set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has('win16') || has('win32')
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

set ruler

set cmdheight=2

set hidden

set ignorecase

set smartcase

set hlsearch

set incsearch

set lazyredraw

set magic

set showmatch
set matchtime=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set timeoutlen=500

if has('gui_macvim')
    autocmd GUIEnter * set vb t_vb=
endif

syntax enable

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
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


" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set showtabline=2
catch
endtry

set laststatus=2

" cursor shape
" Use a blinking upright bar cursor in Insert mode, a blinking block in normal
autocmd VimLeave * let &t_te .= "\<Esc>[3 q"
if &term == 'xterm-256color' || &term == 'screen-256color'
    " when start insert mode - blinking vertical bar
    let &t_SI = "\<Esc>[5 q"
    " when end insert/replace mode(common) - blinking block
    let &t_EI = "\<Esc>[1 q"
    " when start replace mode
    let &t_SR = "\<Esc>[4 q"
endif

if exists('$TMUX')
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
endif


function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction


" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr('%')
   let l:alternateBufNum = bufnr('#')

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr('%') == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute('bdelete! '.l:currentBufNum)
   endif
endfunction

" Make VIM remember position in file after reopen
if has('autocmd')
   au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

if has('mac') || has('macunix')
    set guifont=Hack:h14,Source\ Code\ Pro:h15,Menlo:h15
elseif has('win16') || has('win32')
    set guifont=Hack:h14,Source\ Code\ Pro:h12,Bitstream\ Vera\ Sans\ Mono:h11
elseif has('gui_gtk2')
    set guifont=Hack\ 14,Source\ Code\ Pro\ 12,Bitstream\ Vera\ Sans\ Mono\ 11
elseif has('linux')
    set guifont=Hack\ 14,Source\ Code\ Pro\ 12,Bitstream\ Vera\ Sans\ Mono\ 11
elseif has('unix')
    set guifont=Source\ Code\ Pro\ Medium\ 12
endif

try
    set undodir=~/.vim/temp_dirs/undodir/
    set undofile
catch
endtry

map ½ $
cmap ½ $
imap ½ $
iab _date <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>

func! DeleteTillSlash()
    let g:cmd = getcmdline()

    if has("win16") || has("win32")
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\]\\).*", "\\1", "")
    else
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
    endif

    if g:cmd == g:cmd_edited
        if has("win16") || has("win32")
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
        else
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
        endif
    endif

    return g:cmd_edited
endfunc

au FileType javascript setl nocindent

autocmd BufRead,BufNewFile *.ts setlocal filetype=typescript
autocmd BufNewFile,BufRead .tern-project setlocal filetype=json


if exists('$TMUX')
    set term=screen-256color
endif


let g:bufExplorerDefaultHelp=0
let g:bufExplorerFindActive=1
let g:bufExplorerSortBy='name'


" CTRL-P
let g:ctrlp_working_path_mode = 'rw'
let g:ctrlp_map = '<c-p>'

let g:ctrlp_max_height = 20
let g:ctrlp_custom_ignore = 'node_modules\|^\.DS_Store\|^\.git\|^\.coffee'
let g:ctrlp_max_depth = 20
let g:ctrlp_show_hidden = 1

" command-t
nmap <silent> <Leader>tt <Plug>(CommandT)
nmap <silent> <Leader>tb <Plug>(CommandTBuffer)
nmap <silent> <Leader>tj <Plug>(CommandTJump)


" Nerd Tree
let g:NERDTreeWinPos = 'left'
let g:NERDTreeIgnore = ['\.pyc$', '__pycache__']
let g:NERDTreeWinSize=30
let g:NERDTreeShowHidden = 1
" Nerd tabs
let g:nerdtree_tabs_open_on_gui_startup = 1
let g:nerdtree_tabs_open_on_console_startup = 0
let g:nerdtree_tabs_no_startup_for_diff = 1
let g:nerdtree_tabs_smart_startup_focus = 1
let g:nerdtree_tabs_startup_cd = 1
map <leader>nt :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark
map <leader>nf :NERDTreeFind<cr>


" tmux navigator
" disable default mappings
let g:tmux_navigator_no_mappings = 1


" Utilsnips
let g:UltiSnipsExpandTrigger = '<leader>e'
let g:UltiSnipsListSnippets = '<Leader>l'
let g:UltiSnipsJumpForwardTrigger = '<Leader>ub'
let g:UltiSnipsJumpBackwardTrigger = '<Leader>uz'
let g:UltiSnipsEditSplit = 'vertical'


" editorconfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://*']


"" see help delimitMateExpansion
let g:delimitMate_expand_cr = 2
let g:delimitMate_expand_space = 1
let g:delimitMate_jump_expansion = 1
" let g:delimitMate_balance_matchpairs = 1

" vim-closetag
let g:closetag_filenames = '*.html,*.xhtml,*.xml'
let g:closetag_emptyTags_caseSensitive = 1


" javascript-libraries-syntax
let g:used_javascript_libs = 'jquery,angularjs,angularui,angularuirouter'

" JS pretty template
au FileType javascript JsPreTmpl html
au FileType typescript JsPreTmpl markdown

" vim-javascript
let g:javascript_plugin_jsdoc = 1

" startify
let g:startify_session_dir = '~/.vim/sessions/'
"let g:startify_list_order = ['files', 'dir', 'bookmarks', 'sessions', 'commands']
let g:startify_update_oldfiles = 1
let g:startify_session_autoload = 1
let g:startify_session_persistence = 1
let g:startify_change_to_vcs_root = 1
let g:startify_skiplist = [
      \ '/tmp',
      \ ]
let g:startify_fortune_use_unicode = 1
let g:startify_session_sort = 1
let g:startify_relative_path = 1

" Ale
let g:ale_linters = {
            \ }
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_sign_error = emoji#for('rage')
let g:ale_sign_warning = ':('
nmap <silent> <c-k> <Plug>(ale_previous_wrap)
nmap <silent> <c-j> <Plug>(ale_next_wrap)
" let g:ale_cpp_clangtidy_options = '-std c++14'

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline_theme='onedark'

" markdown
let g:vim_markdown_folding_disabled = 1

let g:markdown_composer_open_browser = 0

" tsuquyomi
let g:tsuquyomi_definition_split = 3   "tabedit
let g:tsuquyomi_single_quote_import = 1

" luochen1990/rainbow
let g:rainbow_active = 1
let g:rainbow_conf = {
	\	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
	\	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
	\	'operators': '_,_',
	\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
	\	'separately': {
	\		'*': {},
	\		'tex': {
	\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
	\		},
	\		'lisp': {
	\			'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
	\		},
	\		'vim': {
	\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
	\		},
	\		'html': {
	\			'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
	\		},
	\		'css': 0,
	\	}
	\}


" junegunn/rainbow_parentheses
let g:rainbow#max_level = 16
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]

augroup rainbow_parentheses
    autocmd!
    autocmd FileType clojure,scheme,html RainbowParentheses
augroup END

" vim-signature
let g:SignatureMap = {
        \ 'Leader'             :  '<Leader>m',
        \ 'PlaceNextMark'      :  '<Leader>m,',
        \ 'ToggleMarkAtLine'   :  '<Leader>m.',
        \ 'PurgeMarksAtLine'   :  '<Leader>m-',
        \ 'DeleteMark'         :  '<Leader>dm',
        \ 'PurgeMarks'         :  '<Leader>m<Space>',
        \ 'PurgeMarkers'       :  '<Leader>m<BS>',
        \ 'GotoNextLineAlpha'  :  '',
        \ 'GotoPrevLineAlpha'  :  '',
        \ 'GotoNextSpotAlpha'  :  '',
        \ 'GotoPrevSpotAlpha'  :  '',
        \ 'GotoNextLineByPos'  :  '',
        \ 'GotoPrevLineByPos'  :  '',
        \ 'GotoNextSpotByPos'  :  '',
        \ 'GotoPrevSpotByPos'  :  '',
        \ 'GotoNextMarker'     :  '',
        \ 'GotoPrevMarker'     :  '',
        \ 'GotoNextMarkerAny'  :  '',
        \ 'GotoPrevMarkerAny'  :  '',
        \ 'ListBufferMarks'    :  '',
        \ 'ListBufferMarkers'  :  ''
        \ }

" incsearch.vim
map <Leader>/ <Plug>(incsearch-forward)
map <Leader>? <Plug>(incsearch-backward)
map <Leader>g/ <Plug>(incsearch-stay)

" vim-wiki
let g:vimwiki_table_mappings = 0

" easy-align
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" vim-a
nnoremap <Leader>is :A<CR>
