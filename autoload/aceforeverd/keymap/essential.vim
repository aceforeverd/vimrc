function!  aceforeverd#keymap#essential#setup() abort
    if !has('nvim')
        " align to nvim default mapings
        nnoremap <C-L> <Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>

        " vim in terminal do not behavior correct with alt
        " see `:help map-alt-keys` and https://vi.stackexchange.com/a/38866
        if !has('gui_running') && &term !~? 'kitty$'
            execute "set <M-j>=\<Esc>j"
            execute "set <M-k>=\<Esc>k"
        endif
    endif

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
    xnoremap <silent> a_ :call <sid>current_line(v:true)<cr>
    onoremap <silent> a_ :call <sid>current_line(v:true)<cr>
    " inside current line
    xnoremap <silent> i_ :call <sid>current_line(v:false)<cr>
    onoremap <silent> i_ :call <sid>current_line(v:false)<cr>

    " whole buffer
    xnoremap gG GoggV
    onoremap gG :normal! VGogg<cr>

    " scroll window and cursor together, cursor location compared to current window not change
    nnoremap <M-j> <C-e>j
    nnoremap <M-k> <C-y>k

    " go to plugin url
    nnoremap gs :call aceforeverd#keymap#browse#try_open()<CR>
    nnoremap <space>gs :call aceforeverd#keymap#browse#try_open(v:true)<CR>

    nnoremap <silent> zS :<c-u>call aceforeverd#util#syn_query()<cr>
    nnoremap <silent> zV :<c-u>call aceforeverd#util#syn_query_verbose()<cr>
endfunction

function! s:current_line(outter) abort
    if col('$') == 1
        return
    endif

    if mode() !=# 'v'
        normal! v
    endif

    if a:outter == v:true
        normal! $ho0
    else
        normal! g_o_
    endif
endfunction
