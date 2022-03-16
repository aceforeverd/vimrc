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

function! plugin_browse#try_open() abort
    let l:uri_list = plugin_browse#get_uri()
    if empty(l:uri_list)
        echomsg 'no plugin uri found in current line ' . line('.') . ' open as url'
        return
    endif

    call plugin_browse#open(l:uri_list)
endfunction

function! plugin_browse#get_uri() abort
    " match uri inside quotes with pattern {owner}/{repo}, support multiple matches in the given string
    let l:matched_list = []
    call substitute(getline('.'), '[''"]\zs[^''"/ ]\+\/[^''"/ ]\+\ze[''"]', '\=add(l:matched_list, submatch(0))', 'g')
    return l:matched_list
endfunction

" TODO: a option to open all plugins once
function! plugin_browse#open(uris) abort
    if type(a:uris) != v:t_string && type(a:uris) != v:t_list
        echomsg 'invalid parameter type'
        return
    endif

    if type(a:uris) == v:t_string
        execute '!open https://github.com/' . a:uris
    elseif len(a:uris) == 1
        call plugin_browse#open(a:uris[0])
    else
        " TODO: selct which one to open
        if has('nvim-0.6.0')
            call v:lua.require'plugin_browse'.select_browse_plugin(a:uris)
        else
            echomsg a:uris
        endif
    endif
endfunction


