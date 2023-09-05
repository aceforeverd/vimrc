" Copyright (C) 2021  Ace <teapot@aceforeverd.com>
"
" This program is free software: you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation, either version 3 of the License, or
" (at your option) any later version.
"
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with this program.  If not, see <http://www.gnu.org/licenses/>.

""
" the plugin install wrapper used by first time installation
"
" @param post_hook: a string to be executed after finish as Ex command
""

function! aceforeverd#util#has_float() abort
    " see https://github.com/neoclide/coc.nvim/wiki/F.A.Q#how-to-make-preview-window-shown-aside-with-pum
    return (has('textprop') && has('patch-8.1.1719')) || (exists('*nvim_open_win'))
endfunction

" good util function to investigate highlight staffs
function! aceforeverd#util#syn_query() abort
    if has('nvim')
        execute 'Inspect'
    else
        if get(g:, 'loaded_scriptease', 0) == 1
            execute 'normal <Plug>ScripteaseSynnames'
        else
            for id in synstack(line('.'), col('.'))
                echomsg synIDattr(id, 'name')
            endfor
        endif
    endif
endfunction

function! aceforeverd#util#syn_query_verbose() abort
    if has('nvim')
        execute 'Inspect!'
    else
        for id in synstack(line('.'), col('.'))
            execute 'highlight' synIDattr(id, 'name')
        endfor
    endif
endfunction

