function! s:apache(...) abort
    " insert full apache license at top of buffer
    let @l = system('curl -s https://www.apache.org/licenses/LICENSE-2.0.txt')

    let pos = get(a:, 1, 0)

    execute pos . "put l | normal `["
endfunction

function! aceforeverd#cmd#essential#setup() abort
    command! -nargs=? Apache silent call <SID>apache(<args>)
endfunction
