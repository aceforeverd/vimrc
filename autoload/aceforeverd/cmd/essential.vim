function! s:apache(...) abort
    " insert full apache license at top of buffer
    let @l = system('curl -s https://www.apache.org/licenses/LICENSE-2.0.txt')

    " put content after line number
    let pos = get(a:, 1, 0)

    execute pos . "put l | normal `["
endfunction

" generate gitignore content after line number
" param2: line number after where generated content should put
function! s:gitignore(...) abort
    " comma(,) splited language list
    let lang = get(a:, 1, "")
    " put content after line number
    let pos = get(a:, 2, line('.'))

    let @l = system('curl -s https://www.toptal.com/developers/gitignore/api/' . lang)

    execute pos . "put l | normal `["
endfunction


function! aceforeverd#cmd#essential#setup() abort
    command! -nargs=? Apache silent call <SID>apache(<args>)
    command! -bang -nargs=0 Gdep call aceforeverd#keymap#browse#try_open(<bang>0)
    command! -nargs=+ GitIgnore silent call <SID>gitignore(<f-args>)
endfunction
