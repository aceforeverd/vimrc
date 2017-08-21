set history=500

filetype plugin on
filetype indent on

set autoread

" global leader
let mapleader = ","
let g:mapleader = ","
" local leader
let maplocalleader = '\\'

set so=4

let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

set ruler

set cmdheight=2

set hid

set ignorecase

set smartcase

set hlsearch

set incsearch

set lazyredraw

set magic

set showmatch
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

if has("gui_macvim")
    autocmd GUIEnter * set vb t_vb=
endif

syntax enable

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif


if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

set encoding=utf8

set ffs=unix,dos,mac

set nu

set expandtab
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines


vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

map <silent> <leader><cr> :noh<cr>
nnoremap <leader>tn :tabnew<cr>
nnoremap <leader>to :tabonly<cr>
nnoremap <leader>tc :tabclose<cr>
nnoremap <leader>tm :tabmove<cr>
nnoremap <leader>tl :tabnext<cr>
nnoremap <leader>th :tabprevious<cr>


let g:lasttab = 1
au TabLeave * let g:lasttab = tabpagenr()


" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
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

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()


function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ag '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
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
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction

" Make VIM remember position in file after reopen
if has("autocmd")
   au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

if has("mac") || has("macunix")
    set gfn=Hack:h14,Source\ Code\ Pro:h15,Menlo:h15
elseif has("win16") || has("win32")
    set gfn=Hack:h14,Source\ Code\ Pro:h12,Bitstream\ Vera\ Sans\ Mono:h11
elseif has("gui_gtk2")
    set gfn=Hack\ 14,Source\ Code\ Pro\ 12,Bitstream\ Vera\ Sans\ Mono\ 11
elseif has("linux")
    set gfn=Hack\ 14,Source\ Code\ Pro\ 12,Bitstream\ Vera\ Sans\ Mono\ 11
elseif has("unix")
    set gfn=Source\ Code\ Pro\ Medium\ 12
endif

try
    set undodir=~/.vim/temp_dirs/undodir/
    set undofile
catch
endtry


cno $q <C-\>eDeleteTillSlash()<cr>

map ½ $
cmap ½ $
imap ½ $

iab xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>


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

func! CurrentFileDir(cmd)
    return a:cmd . " " . expand("%:p:h") . "/"
endfunc

let python_highlight_all = 1
au FileType python syn keyword pythonDecorator True None False self

au BufNewFile,BufRead *.jinja set syntax=htmljinja
au BufNewFile,BufRead *.mako set ft=mako


au FileType javascript setl nocindent


function! JavaScriptFold()
    setl foldmethod=syntax
    setl foldlevelstart=1
    syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

    function! FoldText()
        return substitute(getline(v:foldstart), '{.*', '{...}', '')
    endfunction
    setl foldtext=FoldText()
endfunction


autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])

autocmd BufRead,BufNewFile *.ts setlocal filetype=typescript
autocmd BufNewFile,BufRead .tern-project setlocal filetype=json


if exists('$TMUX')
    set term=screen-256color
endif


" =====================================================================================
"   Plugins
" =====================================================================================

" call pathogen#helptags()


let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1
let g:bufExplorerFindActive=1
let g:bufExplorerSortBy='name'
map <leader>o :BufExplorer<cr>


let MRU_Max_Entries = 400
map <leader>f :MRU<CR>


" CTRL-P
let g:ctrlp_working_path_mode = 'rw'
let g:ctrlp_map = '<c-p>'

let g:ctrlp_max_height = 20
let g:ctrlp_custom_ignore = 'node_modules\|^\.DS_Store\|^\.git\|^\.coffee'
let g:ctrlp_max_depth = 20
let g:ctrlp_show_hidden = 1



" Nerd Tree
let g:NERDTreeWinPos = "left"
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let g:NERDTreeWinSize=25
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
let g:UltiSnipsExpandTrigger = "<leader>e"
let g:UltiSnipsListSnippets = "<c-l>"
let g:UltiSnipsJumpForwardTrigger = "<c-b>"
let g:UltiSnipsJumpBackwardTrigger = "<c-z>"
let g:UltiSnipsEditSplit = "vertical"


" editorconfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://*']


"" see help delimitMateExpansion
let delimitMate_expand_cr = 2
let delimitMate_expand_space = 1
let delimitMate_jump_expansion = 1
let delimitMate_balance_matchpairs = 1

let delimitMate_matchpairs = "(:),[:],{:},<:>"
au FileType html,xml,xhtml let b:delimitMate_matchpairs = "(:),[:],{:}"

" vim-closetag
let g:closetag_filenames = "*.html,*.xhtml,*.xml"
let g:closetag_emptyTags_caseSensitive = 1


" javascript-libraries-syntax
let g:used_javascript_libs = 'jquery,react,angularjs,angularui,angularuirouter'

" JS pretty template
au FileType javascript JsPreTmpl html
au FileType typescript JsPreTmpl markdown


" vim-javascript
let g:javascript_plugin_ngdoc = 1
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1

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


" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline_theme='onedark'

" vim-markdown
let g:vim_markdown_folding_disabled = 1
