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
    " Latex
    " merged = 0 beacue E944: Reverse range in character class
    call minpac#add('lervag/vimtex', {'type': 'opt'})
    " Go
    call minpac#add('fatih/vim-go', {'type': 'opt'})

    if !has('nvim')
        packadd vim-go
        call aceforeverd#settings#vim_go()
    endif
endfunction
