" Default to <quote>username/repo<quote>, for filetype vim,lua,tmux
let g:browse_uri_pattern = {
            \ '*': '[''"]\zs[^''"/ ]\+\/[^''"/ ]\+\ze[''"]',
            \ 'yaml': 'uses:\s\+\zs[^@]\+\/[^@]\+\ze',
            \ 'gomod': '\v\zs([[:alnum:]\._-]+)(\/([[:alnum:]\._-])+)*\ze\s+v.*',
            \ 'gosum': '\v^\zs([[:alnum:]\._-]+)(\/([[:alnum:]\._-])+)*\ze\s+v.*',
            \ 'go': '\v"\zs([[:alnum:]\._-]+)(\/([[:alnum:]\._-])+)*\ze"',
            \ }
let g:browse_uri_fmt = {
            \ 'go': 'https://pkg.go.dev/%s',
            \ 'gomod': 'https://pkg.go.dev/%s',
            \ 'gosum': 'https://pkg.go.dev/%s',
            \ '*': 'https://github.com/%s',
            \ }

" For gomod/gosum filetype: ^domain/sub[/sub ...]
"   since we want remove the optional version suffix (v\d+) in the url, it's important to use '{-}' to match subpath as few as possible,
"   then the suffix removed selection (if exists) if preferred in regex engine.
"   It is not perfect when dealing with upstream string 'github.com/uname/repo/subpath', this path never exists.
let g:browse_upstream_pattern = {
            \ '*': '\v[''"]\zs[^''"/ ]+\/[^''"/ ]+\ze[''"]',
            \ 'gosum': '\v^\zs[[:alnum:]_-]+(\.([[:alnum:]_-])+)+(\/[[:alnum:]_\.-]+){-}(\ze\/v\d+|\ze)\s+v.*',
            \ 'gomod': '\v\zs[[:alnum:]_-]+(\.([[:alnum:]_-])+)+(\/[[:alnum:]_\.-]+){-}(\ze\/v\d+|\ze)\s+v.*',
            \ }
let g:browse_upstream_fmt = {
            \ '*': 'https://github.com/%s',
            \ 'go': 'https://%s',
            \ 'gomod': 'https://%s',
            \ 'gosum': 'https://%s',
            \ }

function! aceforeverd#keymap#browse#try_open(go_upstream = v:false) abort
    let l:pattern = ''
    let l:fmt = ''
    " default pattern: quotes with inside {owner}/{repo}, support multiple matches in the given string
    if !a:go_upstream
        let l:pattern = get(g:browse_uri_pattern, &filetype, get(g:browse_uri_pattern, '*', ''))
        let l:fmt = get(g:browse_uri_fmt, &filetype, get(g:browse_uri_fmt, '*', ''))
    else
        let l:pattern = get(g:browse_upstream_pattern, &filetype, get(g:browse_upstream_pattern, '*', ''))
        let l:fmt = get(g:browse_upstream_fmt, &filetype, get(g:browse_upstream_fmt, '*', ''))
    endif

    if l:pattern == ''
        echomsg 'no url patern specified for filetype ' . &filetype
        return
    endif

    if l:fmt == ''
        echomsg 'no fmt patern specified for filetype ' . &filetype
        return
    endif

    let l:matched_list = []
    call substitute(getline('.'), l:pattern, '\=add(l:matched_list, printf(l:fmt, submatch(0)))', 'g')

    call aceforeverd#keymap#browse#open(l:matched_list)
endfunction

" TODO: a option to open all plugins once
function! aceforeverd#keymap#browse#open(uris) abort
    if type(a:uris) != v:t_string && type(a:uris) != v:t_list
        echomsg 'invalid parameter type'
        return
    endif

    if type(a:uris) == v:t_string
        call aceforeverd#keymap#browse#open_uri(a:uris)
    elseif len(a:uris) == 1
        call aceforeverd#keymap#browse#open(a:uris[0])
    else
        if len(a:uris) == 0
            echomsg "no url found"
            return
        endif

        if has('nvim-0.6.0')
            call v:lua.require'aceforeverd.keymap'.select_browse_plugin(a:uris)
        else
            echomsg a:uris
        endif
    endif
endfunction


""
" open the uri
""
function! aceforeverd#keymap#browse#open_uri(uri) abort
    let l:open = ''
    if has('mac')
        let l:open = 'open'
    elseif has('unix')
        let l:open = 'xdg-open'
    endif

    execute '!' .. l:open .. ' ' .. a:uri
endfunction
