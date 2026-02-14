""
" setup plugins with minpac
""

function! aceforeverd#plugin#setup() abort
    call s:pre_cmds()
    call s:config_plugins()
endfunction

" 'packadd!' variant that (!) is silent
function! s:pack_add(bang, name) abort
    " silent(!) applied just in case exception in vim, if plugin not installed yet
    if a:bang
        silent! execute 'packadd! ' . a:name
    else
        execute 'packadd! ' . a:name
    endif
endfunction

function! PackList(...) abort
    call aceforeverd#plugin#init()
    return join(sort(keys(minpac#getpluglist())), "\n")
endfunction

function! s:pack_open_in_term(name) abort
    let dir = minpac#getpluginfo(substitute(a:name, '\(^\s*\|\s*$\)', '', 'g')).dir
    exe 'FloatermNew --cwd=' . dir
endfunction

function! s:pack_open_dir(name) abort
    let dir = minpac#getpluginfo(substitute(a:name, '\(^\s*\|\s*$\)', '', 'g')).dir
    exe 'edit' dir
endfunction

function! s:pack_reinstall(name) abort
    let canonical_name = substitute(a:name, '\(^\s*\|\s*$\)', '', 'g')
    let dir = minpac#getpluginfo(canonical_name).dir
    call delete(dir, 'rf')
    call minpac#update(a:name)
endfunction

function! s:pre_cmds() abort
    " tiny wrapper for :packadd
    " good thing is use :PackAdd! to ignore any errors and do not terminate,
    " this may helpful when first install and plugins not installed yet
    command! -bang -complete=packadd -nargs=1 PackAdd call s:pack_add(<bang>0, <f-args>)

    command! PackUpdate call aceforeverd#plugin#init() | call minpac#update()
    command! PackStatus call aceforeverd#plugin#init() | call minpac#status()
    command! PackClean  call aceforeverd#plugin#init() | call minpac#clean()

    command! -nargs=1 -complete=custom,PackList PackInstall
                \ call aceforeverd#plugin#init() | call minpac#update(substitute(<q-args>, '\(^\s*\|\s*$\)', '', 'g'))
    command! -nargs=0 PackInstallMissing
                \ call aceforeverd#plugin#init() | call minpac#update(keys(filter(copy(minpac#getpluglist()), {-> !isdirectory(v:val.dir . '/.git')})))

    command! -nargs=1 -complete=custom,PackList PackOpenTerm
                \ call aceforeverd#plugin#init() | call <SID>pack_open_in_term(<q-args>)

    command! -nargs=1 -complete=custom,PackList PackOpenDir
                \ call aceforeverd#plugin#init() | call <SID>pack_open_dir(<q-args>)

    command! -nargs=1 -complete=custom,PackList PackOpenUrl
                \ call aceforeverd#plugin#init() | call aceforeverd#keymap#browse#open_uri(minpac#getpluginfo(substitute(<q-args>, '\(^\s*\|\s*$\)', '', 'g')).url)

    command! -nargs=1 -complete=custom,PackList PackReinstall
                \ call aceforeverd#plugin#init() | call <sid>pack_reinstall(<q-args>)
endfunction

function! s:plugin_add(...) abort
    call call('minpac#add', a:000)
endfunction

function! aceforeverd#plugin#init() abort
    if get(g:, 'initialized_minpac', 0) != 0
        return
    endif
    let g:initialized_minpac = 1

    if has('nvim')
        let s:pack_path = stdpath('data') . '/site/'
    else
        let s:pack_path = $HOME . '/.vim'
    endif
    let s:minpac_path = s:pack_path . '/pack/minpac/opt/minpac'

    if empty(glob(s:minpac_path))
        echomsg "Installing minpac to " . s:minpac_path . ' ...'
        call system(join([ 'git', 'clone', 'https://github.com/k-takata/minpac', s:minpac_path ]))
    endif

    packadd minpac

    call minpac#init({'dir': s:pack_path})

    call s:plugin_add('Shougo/neco-vim', {'type': 'opt'})

    call s:plugin_add('voldikss/vim-floaterm')

    call s:plugin_add('tpope/vim-endwise')
    call s:plugin_add('tpope/vim-surround')
    call s:plugin_add('tpope/vim-ragtag')
    call s:plugin_add('tpope/vim-dispatch')
    call s:plugin_add('tpope/vim-rhubarb')
    call s:plugin_add('tpope/vim-abolish')
    call s:plugin_add('tpope/vim-repeat')
    call s:plugin_add('tpope/vim-scriptease')
    call s:plugin_add('tpope/vim-unimpaired')
    call s:plugin_add('tpope/vim-eunuch')
    call s:plugin_add('tpope/vim-speeddating')
    call s:plugin_add('tpope/vim-obsession')
    call s:plugin_add('tpope/vim-tbone')
    call s:plugin_add('tpope/vim-dadbod')
    call s:plugin_add('tpope/vim-projectionist')
    call s:plugin_add('tpope/vim-sleuth')
    call s:plugin_add('tpope/vim-apathy')
    call s:plugin_add('tpope/vim-characterize')
    call s:plugin_add('tpope/vim-rsi')
    call s:plugin_add('tpope/vim-capslock')

    call s:plugin_add('lambdalisue/suda.vim')

    " snippets
    call s:plugin_add('honza/vim-snippets')

    " interface
    call s:plugin_add('ryanoasis/vim-devicons')
    call s:plugin_add('mhinz/vim-startify', {'type': 'opt'})
    call s:plugin_add('ntpeters/vim-better-whitespace')
    call s:plugin_add('wincent/terminus')
    call s:plugin_add('vifm/vifm.vim')
    call s:plugin_add('justinmk/vim-gtfo')

    " motion
    call s:plugin_add('rhysd/clever-f.vim')
    call s:plugin_add('justinmk/vim-sneak')
    call s:plugin_add('andymass/vim-matchup')
    call s:plugin_add('chaoren/vim-wordmotion', {'type': 'opt'})
    " Tools
    " neovim core already and vim will have editorconfig builtin
    call s:plugin_add('editorconfig/editorconfig-vim', {'name': 'editorconfig', 'type': 'opt'})
    call s:plugin_add('dstein64/vim-startuptime')
    call s:plugin_add('AndrewRadev/bufferize.vim')
    call s:plugin_add('tyru/open-browser.vim')
    call s:plugin_add('wincent/ferret')
    call s:plugin_add('ojroques/vim-oscyank')
    call s:plugin_add('ludovicchabant/vim-gutentags')
    call s:plugin_add('skywind3000/gutentags_plus', {'type': 'opt'})

    call s:plugin_add('alpertuna/vim-header')
    " code format
    call s:plugin_add('sbdchd/neoformat')
    " run/debug/test
    call s:plugin_add('vim-test/vim-test')
    call s:plugin_add('skywind3000/asyncrun.vim')
    call s:plugin_add('jpalardy/vim-slime')
    call s:plugin_add('preservim/vimux')
    call s:plugin_add('tmux-plugins/vim-tmux')
    call s:plugin_add('christoomey/vim-tmux-navigator')

    " VCS
    call s:plugin_add('tpope/vim-fugitive')
    call s:plugin_add('junegunn/gv.vim')
    call s:plugin_add('rhysd/committia.vim')

    " search
    call s:plugin_add('junegunn/fzf', {
                \ 'do': '!./install --all'
                \ })
    call s:plugin_add('junegunn/fzf.vim')

    call s:plugin_add('mbbill/undotree')
    call s:plugin_add('jamessan/vim-gnupg')

    call s:plugin_add('tomtom/tcomment_vim')
    call s:plugin_add('chrisbra/recover.vim')
    " text object manipulate
    call s:plugin_add('AndrewRadev/splitjoin.vim')
    call s:plugin_add('AndrewRadev/sideways.vim')
    call s:plugin_add('AndrewRadev/tagalong.vim')
    call s:plugin_add('AndrewRadev/switch.vim')
    call s:plugin_add('chrisbra/NrrwRgn')
    call s:plugin_add('machakann/vim-sandwich')
    " Debug
    call s:plugin_add('puremourning/vimspector', {'type': 'opt'})

    " ft plugins
    call s:plugin_add('HerringtonDarkholme/yats.vim')
    call s:plugin_add('ziglang/zig.vim')
    call s:plugin_add('gentoo/gentoo-syntax')
    call s:plugin_add('chrisbra/csv.vim')
    call s:plugin_add('rust-lang/rust.vim')
    call s:plugin_add('rhysd/vim-llvm')
    call s:plugin_add('vim-ruby/vim-ruby')
    call s:plugin_add('lervag/vimtex', {'type': 'opt'})
    call s:plugin_add('fatih/vim-go', {'type': 'opt'})
    call s:plugin_add('neoclide/jsonc.vim')
    call s:plugin_add('MTDL9/vim-log-highlighting')
    call s:plugin_add('grafana/vim-alloy')

    " vimL
    call s:plugin_add('tweekmonster/helpful.vim')

    call s:plugin_add('iamcco/markdown-preview.nvim', {
                \ 'type': 'opt',
                \ 'do': '!./app/install.sh'
                \ })

    call s:plugin_add('k-takata/minpac', {'type': 'opt'})

    " vim only
    call s:plugin_add('itchyny/lightline.vim', {'type': 'opt'})
    call s:plugin_add('airblade/vim-gitgutter', {'type': 'opt'})

    call s:plugin_add('justinmk/vim-dirvish', {'type': 'opt'})
    call s:plugin_add('tpope/vim-vinegar', {'type': 'opt'})

    call s:plugin_add('neoclide/coc.nvim', {'type': 'opt',
                \ 'rev': 'release' })
    call s:plugin_add('antoinemadec/coc-fzf', {'type': 'opt'})
    call s:plugin_add('neoclide/coc-neco', {'type': 'opt'})
    call s:plugin_add('airblade/vim-rooter', {'type': 'opt'})

    " auto pair
    call s:plugin_add('raimondi/delimitmate', {'type': 'opt'})

    call s:plugin_add('kristijanhusak/vim-dadbod-ui')

    call s:plugin_add('sainnhe/sonokai', {'type': 'opt'})
    call s:plugin_add('sainnhe/everforest', {'type': 'opt'})
    call s:plugin_add('chrisbra/unicode.vim')

    call s:plugin_add('voldikss/vim-translator')

    call s:plugin_add('kkoomen/vim-doge', {'type': 'opt', 'do': 'packadd vim-doge | call doge#install()'})
endfunction

function! s:config_plugins() abort
    " no matchit & matchparen
    let g:loaded_matchit = 1
    let g:loaded_matchparen = 1

    " load plugins
    PackAdd! cfilter
    " early load colorschem, ref https://github.com/sainnhe/gruvbox-material/issues/60
    PackAdd! sonokai
    PackAdd! everforest

    let g:sleuth_go_heuristics = 0

    if !has('nvim')
        call s:config_vim_only()
    endif

    if g:my_dir_viewer ==? 'dirvish'
        PackAdd! vim-dirvish
        " sort folders at top
        let g:dirvish_mode = ':sort /^.*[\/]/'

    elseif g:my_dir_viewer ==? 'netrw'
        PackAdd! vim-vinegar
    endif

    if !has('nvim-0.5.0')
        PackAdd! lightline.vim

        call aceforeverd#statusline#lightline()

        PackAdd! vim-gitgutter
        nmap <Leader>hr <Plug>(GitGutterUndoHunk)
        omap ih <Plug>(GitGutterTextObjectInnerPending)
        omap ah <Plug>(GitGutterTextObjectOuterPending)
        xmap ih <Plug>(GitGutterTextObjectInnerVisual)
        xmap ah <Plug>(GitGutterTextObjectOuterVisual)
        let g:gitgutter_sign_added = '+'
        let g:gitgutter_preview_win_floating = 1
        let g:gitgutter_sign_modified = '~'
        if has('nvim-0.4.0')
            let g:gitgutter_highlight_linenrs = 1
        endif
    endif

    " suda.vim
    command! SudaWrite exe 'w suda://%'
    command! SudaRead  exe 'e suda://%'

    let g:floaterm_width = 0.9
    let g:floaterm_height = 0.9

    " terminal mode mapping
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

    augroup gp_filetype
        autocmd!
        autocmd FileType verilog,verilog_systemverilog setlocal nosmartindent
        autocmd FileType javascript setlocal nocindent
    augroup END

    " fzf
    nnoremap <c-p> :FZF --info=inline<CR>
    function! s:build_quickfix_list(lines) abort
        call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
        copen
        cc
    endfunction
    let g:fzf_action = {
                \ 'alt-q': function('s:build_quickfix_list'),
                \ 'ctrl-t': 'tab split',
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
    if !has('nvim')
        nnoremap <Space>r :Rg<CR>
        nnoremap <Space>c :Commands<CR>
        nnoremap <Space>f :Files<CR>
        nnoremap <Space>b :Buffers<CR>
        nnoremap <Space>T :Tags<CR>
    endif
    nnoremap <Space>B :BLines<CR>
    nnoremap <Space>L :Lines<CR>

    " GGrep <pattern>
    command! -bang -nargs=* GGrep
                \ call fzf#vim#grep(
                \   'git grep --line-number -- '.shellescape(<q-args>), 0,
                \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

    " SG <sg pattern>. relaunch sg on every keystroke
    " TODO: sg pattern do not work well with single quote pattern
    command! -bang -nargs=* SG
                \ call fzf#vim#grep2(
                \   'ast-grep run --heading never --pattern ', <q-args>, 0,
                \   fzf#vim#with_preview(), <bang>0)

    " more for vim-rsi
    let g:rsi_no_meta = 1
    " <c-a> & <c-e> -> <HOME> & <END>, <c-b> & <c-f> -> forward & backward
    " inoremap        <C-A> <C-O>^
    " inoremap   <C-X><C-A> <C-A>
    " cnoremap        <C-A> <Home>
    " cnoremap   <C-X><C-A> <C-A>

    " i_CRTL-E insert the char below cursor
    " inoremap <expr> <C-E> col('.')>strlen(getline('.'))<bar><bar>pumvisible()?"\<Lt>C-E>":"\<Lt>End>"
    inoremap <C-\><C-E> <C-E>

    " no i_CTRL-B
    " inoremap <expr> <C-B> getline('.')=~'^\s*$'&&col('.')>strlen(getline('.'))?"0\<Lt>C-D>\<Lt>Esc>kJs":"\<Lt>Left>"
    " go back one char, use remapped <C-A> for c_CTRL-B
    " cnoremap        <C-B> <Left>

    " inoremap <expr> <C-F> col('.')>strlen(getline('.'))?"\<Lt>C-F>":"\<Lt>Right>"
    " cnoremap <expr> <C-F> getcmdpos()>strlen(getcmdline())?&cedit:"\<Lt>Right>"
    inoremap <C-\><C-F> <C-F>

    if executable('rg')
        set grepprg=rg\ --vimgrep\ --smart-case\ --no-heading\ --no-config
    endif

    if !has('nvim-0.9.0')
        PackAdd! editorconfig
        " editorconfig
        let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://*']
    endif

    " vim-markdown
    let g:markdown_fenced_languages = ['html', 'json', 'javascript', 'c', 'bash=sh', 'vim', 'help']
    let g:mkdp_auto_close = 0

    " markdown local settings
    function! s:mk_hook() abort
        packadd markdown-preview.nvim
        map <buffer> <leader>mp <Plug>MarkdownPreview
    endfunction
    augroup gp_markdown
        autocmd!
        autocmd FileType markdown,rmd,pandoc.markdown :call s:mk_hook()
        autocmd FileType markdown,rmd,pandoc.markdown,gitcommit setlocal spell
    augroup END

    " vim-sneak
    let g:sneak#label = 1
    let g:sneak#s_next = 1 " go the next/previous match by s/S, same as clever-f
    " WARN(MAY CHANGE LATER): mapping <tab>/<s-tab> are not necessary since sneak#s_next enabled
    nmap <silent> <expr> <tab> sneak#is_sneaking() ? '<Plug>Sneak_;' : '<TAB>'
    nmap <silent> <expr> <s-tab> sneak#is_sneaking() ? '<Plug>Sneak_,' : '<S-TAB>'

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
    let g:tmux_navigator_preserve_zoom = 1
    nnoremap <silent> <c-w>j :call <sid>smart_window_jump('j')<cr>
    nnoremap <silent> <c-w>k :call <sid>smart_window_jump('k')<cr>
    nnoremap <silent> <c-w>h :call <sid>smart_window_jump('h')<cr>
    nnoremap <silent> <c-w>l :call <sid>smart_window_jump('l')<cr>
    nnoremap <silent> <c-w>p :call <sid>smart_window_jump("#")<cr>

    augroup gp_lookup
        autocmd!
        autocmd FileType vim,lua,help nnoremap <buffer> <leader>gh :call aceforeverd#completion#help()<cr>
    augroup END

    " open-browser
    command! OpenB execute 'normal <Plug>(openbrowser-open)'
    vmap <Leader>os <Plug>(openbrowser-search)

    " ferret
    let g:FerretMap = 0
    let g:FerretExecutableArguments = {
                \ 'rg': '--vimgrep --no-heading --no-config --smart-case'
                \ }

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
    " in case conflicts with sneak
    omap <leader>% <plug>(matchup-z%)

    " vim-translator
    let g:translator_default_engines = ['google']
    let g:translator_history_enable = 1
    nmap <silent> <Leader>tr <Plug>TranslateW
    vmap <silent> <Leader>tr <Plug>TranslateWV

    " vimspector
    let g:vimspector_enable_mappings = 'HUMAN'

    " switch.vim
    let g:switch_mapping = '<space>x'

    " vim gtfo
    nnoremap <expr> goo 'go'

    " vim-sandwich
    let g:operator_sandwich_no_default_key_mappings = 1

    " csv.vim
    let g:csv_no_conceal = 1

    " vim-wordmotion
    let g:wordmotion_prefix = ';'

    " zig
    let g:zig_fmt_autosave = 0

    " llvm
    let g:llvm_ext_no_mapping = 0

    " terminus has different defaults for cursor shape, disable it
    let g:TerminusCursorShape = 0

    PackAdd! vim-doge
    let g:doge_enable_mappings = 0
    let g:doge_mapping_comment_jump_forward = '<c-j>'
    let g:doge_mapping_comment_jump_backward = '<c-k>'

    let g:slime_no_mappings = 1

    " vim rooter
    PackAdd! vim-rooter
    let g:rooter_cd_cmd = 'lcd'

    call aceforeverd#tags#setup()
endfunction

function! s:config_vim_only() abort
    PackAdd! vim-go
    let g:go_fmt_autosave = 0
    let g:go_imports_autosave = 0
    let g:go_mod_fmt_autosave = 0
    let g:go_doc_popup_window = 1
    let g:go_term_enabled = 1
    let g:go_def_mapping_enabled = 0
    let g:go_doc_keywordprg_enabled = 0
    let g:go_gopls_enabled = 0

    PackAdd! vim-wordmotion

    PackAdd! delimitmate
    let g:delimitMate_expand_cr = 2
    let g:delimitMate_expand_space = 1
    let g:delimitMate_balance_matchpairs = 1
    augroup delimitMateCustom
        autocmd!
        autocmd FileType html,xhtml,xml let b:delimitMate_matchpairs = "(:),[:],{:}"
        autocmd FileType rust let b:delimitMate_quotes = "\" `"
    augroup END

    call s:coc()

    " startify
    PackAdd! vim-startify
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

endfunction

function! s:coc() abort
    PackAdd! coc.nvim
    PackAdd! coc-fzf
    PackAdd! neco-vim
    PackAdd! coc-neco

    let g:coc_fzf_preview = 'up:80%'

    call aceforeverd#completion#init_cmp_source(g:my_cmp_source)
endfunction

let s:direction_dict = {
            \ 'h': ['TmuxNavigateLeft', 'h'],
            \ 'l': ['TmuxNavigateRight', 'l'],
            \ 'j': ['TmuxNavigateDown', 'j'],
            \ 'k': ['TmuxNavigateUp', 'k'],
            \ '#': ['TmuxNavigatePrevious', 'p'],
            \ }

" direction is 'hjkl#', refer winnr()
function! s:smart_window_jump(direction) abort
    if getenv('TMUX') != v:null
        let nei_win = winnr(a:direction)

        if nei_win !=# 0 && nei_win ==# winnr()
            execute s:direction_dict[a:direction][0]
        endif
    endif

    execute "normal! \<c-w>" . s:direction_dict[a:direction][1]
endfunction
