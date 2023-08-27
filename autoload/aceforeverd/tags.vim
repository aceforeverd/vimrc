let s:cs_cmds = [
            \ [ 'a', 'Assignments to this symbol', '<C-R><C-W><cr>' ],
            \ [ 'c', 'Functions calling this function', '<C-R><C-W><cr>' ],
            \ [ 'd', 'Functions called by this function', '<C-R><C-W><cr>' ],
            \ [ 'e', 'Egrep pattern', '<C-R><C-W><cr>' ],
            \ [ 'f', 'Find the file', '<C-R>=expand("<cfile>")<cr><cr>' ],
            \ [ 'g', 'Find definition', '<C-R><C-W><cr>' ],
            \ [ 'i', 'Files #including this file', '<C-R>=expand("<cfile>")<cr><cr>' ],
            \ [ 's', 'C symbol', '<C-R><C-W><cr>' ],
            \ [ 't', 'Text string', '<C-R><C-W><cr>' ],
            \ ]

function! aceforeverd#tags#setup() abort
    " ctags for vim's 'tags' feature
    " gtags primary for use with 'cscope' feature
    " gtags_cscope is fine for nvim 0.9.0, since gutentags_plus simulate it
    let g:gutentags_modules = [ 'ctags', 'gtags_cscope' ]
    let g:gutentags_plus_nomap = 1
    if has('nvim-0.9.0')
        let g:gutentags_modules += ['cscope_maps']
    endif
    let g:gutentags_file_list_command = {
                \ 'markers': {
                \   '.git': 'git ls-files',
                \   'default': 'fd',
                \ }
                \ }

    for [action, desc, suffix] in s:cs_cmds
        call s:set_map(action, suffix)
    endfor
endfunction


function! s:set_map(action, suffix) abort
    execute 'nnoremap <space>g' . a:action . ' :GscopeFind ' . a:action . ' ' . a:suffix
    execute printf('xnoremap <space>g%s :call <SID>visual_gs_find("%s")<cr>', a:action, a:action)
endfunction

function! s:visual_gs_find(action) abort
    execute 'normal! `<v`>"cy'
    execute 'GscopeFind ' . a:action . ' ' . getreg('c')
endfunction
