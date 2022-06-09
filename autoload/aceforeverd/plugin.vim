""
" setup minpac plugins and config them
""
function! aceforeverd#plugin#minpac() abort
    if has('nvim')
        let s:pack_path = stdpath('data') . '/site/'
    else
        let s:pack_path = $HOME . '/.vim'
    endif
    let s:minpac_path = s:pack_path . '/pack/minpac/opt/minpac'

    if empty(glob(s:minpac_path))
        echomsg 'installing minpac into ' . s:minpac_path
        call system(join([ 'git', 'clone', 'https://github.com/k-takata/minpac', s:minpac_path ]))
        echomsg 'installed minpac'
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
    call minpac#add('vim-airline/vim-airline', {'type': 'opt'})
    call minpac#add('airblade/vim-gitgutter', {'type': 'opt'})

    call minpac#add('justinmk/vim-dirvish', {'type': 'opt'})
    call minpac#add('tpope/vim-vinegar', {'type': 'opt'})

    " auto pair
    call minpac#add('raimondi/delimitmate', {'type': 'opt'})
    call minpac#add('cohama/lexima.vim', {'type': 'opt'})

    if !has('nvim')
        packadd! vim-go
        call aceforeverd#settings#vim_go()
    endif

    if g:my_dir_viewer ==? 'dirvish'
        packadd! vim-dirvish
    elseif g:my_dir_viewer ==? 'netrw'
        packadd! vim-vinegar
    endif

    if !has('nvim-0.5.0')
        packadd! vim-airline

        let g:airline#extensions#tabline#enabled = 1
        let g:airline_detect_modified=1
        let g:airline_detect_paste=1
        let g:airline_theme='sonokai'
        let g:airline_powerline_fonts = 1

        packadd! vim-gitgutter
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
endfunction

function! s:auto_pair() abort
    if g:my_autopair ==? 'delimitmate'
        packadd! delimitmate
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
        packadd! lexima.vim
    endif
endfunction
