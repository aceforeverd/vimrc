""
" setup minpac plugins and config them
""

" tiny wrapper for :packadd
" good thing is use :PackAdd! to ignore any errors and do not terminate,
" this may helpful when first install and plugins not installed yet
command! -bang -nargs=1 PackAdd call s:pack_add(<bang>0, <f-args>)

function! s:pack_add(bang, name) abort
    " looks like it's ok to just 'packadd! plugin' in neovim
    " silent! applied just in case exception in vim, when plugin not found in fs
    if a:bang
        silent! execute 'packadd! ' .. a:name
    else
        execute 'packadd! ' .. a:name
    endif
endfunction

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
    " Go
    call minpac#add('fatih/vim-go', {'type': 'opt'})

    call minpac#add('justinmk/vim-dirvish', {'type': 'opt'})
    call minpac#add('tpope/vim-vinegar', {'type': 'opt'})

    " load opt plugins
    " ignore errors because plugins may not installed from first time
    if !has('nvim')
        PackAdd! vim-go
        call aceforeverd#settings#vim_go()
    endif

    if g:my_dir_viewer ==? 'dirvish'
        PackAdd! vim-dirvish
    elseif g:my_dir_viewer ==? 'netrw'
        PackAdd! vim-vinegar
    endif
endfunction
