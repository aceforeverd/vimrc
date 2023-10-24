
function! aceforeverd#keymap#browse#try_open() abort
    let l:uri_list = aceforeverd#keymap#browse#get_uri()
    if empty(l:uri_list)
        echomsg 'no plugin uri found here, line ' . line('.')
        return
    endif

    call aceforeverd#keymap#browse#open(l:uri_list)
endfunction

function! aceforeverd#keymap#browse#get_uri() abort
    " default pattern: quotes with inside {owner}/{repo}, support multiple matches in the given string
    let l:pattern = get(b:, 'uri_pattern', '')
    if l:pattern == ''
        echomsg 'no url patern specified for filetype ' . &filetype
        return []
    endif

    let l:matched_list = []
    call substitute(getline('.'), l:pattern, '\=add(l:matched_list, submatch(0))', 'g')
    return l:matched_list
endfunction

" TODO: a option to open all plugins once
function! aceforeverd#keymap#browse#open(uris) abort
    if type(a:uris) != v:t_string && type(a:uris) != v:t_list
        echomsg 'invalid parameter type'
        return
    endif

    if type(a:uris) == v:t_string
        call aceforeverd#keymap#browse#open_uri('https://github.com/' .. a:uris)
    elseif len(a:uris) == 1
        call aceforeverd#keymap#browse#open(a:uris[0])
    else
        if has('nvim-0.6.0')
            call v:lua.require'aceforeverd.keymap'.select_browse_plugin(a:uris)
        else
            echomsg a:uris
        endif
    endif
endfunction


""
" open the uri
" if open-browser.vim intalled, use openbrowser#open
" otherwise, !open
""
function! aceforeverd#keymap#browse#open_uri(uri) abort
    if get(g:, 'loaded_openbrowser', 0) == 1
        call openbrowser#open(a:uri)
        return
    endif

    let l:open = ''
    if has('mac')
        let l:open = 'open'
    elseif has('unix')
        let l:open = 'xdg-open'
    endif

    execute '!' .. l:open .. ' ' .. a:uri
endfunction
