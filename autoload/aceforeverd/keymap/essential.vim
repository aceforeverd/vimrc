function!  aceforeverd#keymap#essential#setup() abort
    " in case can't go back with t/T/f/F
    nnoremap ,, ,
    " vim default ;, is not necessary with clever-f
    " NOTE: ; may used for other maps

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

    " ===========================
    " Text Objects
    " ==========================

    " around current line
    xnoremap a_ 0o$
    " inside current line
    xnoremap i_ _og_

    " scroll window and cursor together, cursor location compared to current window not change
    nnoremap <M-j> <C-e>j
    nnoremap <M-k> <C-y>k

    if !has('nvim')
        " align to nvim default mapings
        nnoremap <C-L> <Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>
    endif
endfunction
