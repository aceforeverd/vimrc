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


