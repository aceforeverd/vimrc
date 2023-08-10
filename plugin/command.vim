function! s:apache() abort
    " insert license below current line
    " if current line is empty: delete it afterwards
    let @l = system('curl -s https://www.apache.org/licenses/LICENSE-2.0.txt')
    let cur_line = line('.')

    execute "put l | normal `["

    if getline(cur_line) ==# ''
        call deletebufline('', cur_line)
    endif
endfunction

command! Apache silent call <SID>apache()
