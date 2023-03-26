""
" setup minpac plugins and config them
""

function! s:pack_add(bang, name) abort
    " looks like it's ok to just 'packadd! plugin' in neovim
    " silent! applied just in case exception in vim, when plugin not found in fs
    if a:bang
        silent! execute 'packadd! ' .. a:name
    else
        execute 'packadd! ' .. a:name
    endif
endfunction

function! s:init_cmds() abort
    " tiny wrapper for :packadd
    " good thing is use :PackAdd! to ignore any errors and do not terminate,
    " this may helpful when first install and plugins not installed yet
    command! -bang -nargs=1 PackAdd call s:pack_add(<bang>0, <f-args>)

    command! MinUpdate call minpac#update()
    command! MinStatus call minpac#status()
    command! MinClean call minpac#clean()
endfunction

function! aceforeverd#plugin#minpac() abort
    call s:init_cmds()

    if has('nvim')
        let s:pack_path = stdpath('data') . '/site/'
    else
        let s:pack_path = $HOME . '/.vim'
    endif
    let s:minpac_path = s:pack_path . '/pack/minpac/opt/minpac'

    if empty(glob(s:minpac_path))
        call system(join([ 'git', 'clone', 'https://github.com/k-takata/minpac', s:minpac_path ]))
    endif

    packadd minpac

    call minpac#init({'dir': s:pack_path})

    call minpac#add('k-takata/minpac', {'type': 'opt'})
    call minpac#add('jalvesaq/Nvim-R', {'type': 'opt'})
    call minpac#add('mg979/docgen.vim')

    " Latex
    " merged = 0 beacue E944: Reverse range in character class
    call minpac#add('lervag/vimtex', {'type': 'opt'})

    " vim only
    " Go
    call minpac#add('fatih/vim-go', {'type': 'opt'})
    call minpac#add('itchyny/lightline.vim', {'type': 'opt'})
    call minpac#add('airblade/vim-gitgutter', {'type': 'opt'})

    call minpac#add('justinmk/vim-dirvish', {'type': 'opt'})
    call minpac#add('tpope/vim-vinegar', {'type': 'opt'})

    call minpac#add('neoclide/coc.nvim', {'type': 'opt',
                \ 'rev': 'release' })
    call minpac#add('antoinemadec/coc-fzf', {'type': 'opt'})
    call minpac#add('neoclide/coc-neco', {'type': 'opt'})

    " load opt plugins
    " ignore errors because plugins may not installed from first time

    " auto pair
    call minpac#add('raimondi/delimitmate', {'type': 'opt'})
    call minpac#add('cohama/lexima.vim', {'type': 'opt'})

    call minpac#add('kristijanhusak/vim-dadbod-ui')

    call minpac#add('sainnhe/sonokai')
    call minpac#add('chrisbra/unicode.vim')

    let g:polyglot_disabled = ['sensible', 'autoindent', 'go']
    let g:vim_json_syntax_conceal = 1
    call minpac#add('sheerun/vim-polyglot')

    call minpac#add('kovisoft/slimv')

    call minpac#add('aceforeverd/vim-translator', {'branch': 'dev'})

    " load plugins
    PackAdd! cfilter

    if !has('nvim')
        PackAdd! vim-go
        call aceforeverd#settings#vim_go()
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

    call s:auto_pair()
    if g:my_cmp_source ==? 'coc'
        call s:coc()
    endif
endfunction

function! s:auto_pair() abort
    if g:my_autopair ==? 'delimitmate'
        PackAdd! delimitmate
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
        PackAdd! lexima.vim
    endif
endfunction

function! s:coc() abort
    PackAdd! coc.nvim
    PackAdd! coc-fzf
    PackAdd! coc-neco

   let g:coc_fzf_preview = 'up:80%'
endfunction
