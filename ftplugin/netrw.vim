
" vinegar
call s:enhance_netrw()

function! s:enhance_netrw() abort
    highlight netrwSuffixes ctermfg=250 ctermbg=235 guifg=#e4e3e1 guibg=#312c2b
    setlocal bufhidden=wipe
    nnoremap <buffer> gq <Cmd>Rexplore<cr>
endfunction
