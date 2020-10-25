function! plugin_browse#try_open() abort
    let l:uri = plugin_browse#get_uri()
    call plugin_browse#open(l:uri)
endfunction

function! plugin_browse#get_uri() abort
    " match uri inside quotes with pattern {owner}/{repo}
    return matchstr(getline('.'), '[''"]\zs[^''"/ ]\+\/[^''"/ ]\+\ze[''"]')
endfunction

function! plugin_browse#open(uri) abort
    if empty(a:uri)
        echomsg 'no plugin uri found in line ' . line('.') . ' open as url'
    else
        execute '!open https://github.com/' . a:uri
    endif
endfunction


