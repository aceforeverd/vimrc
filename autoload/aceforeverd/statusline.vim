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

function! aceforeverd#statusline#nvim_gps() abort
    return v:lua.require('aceforeverd.utility.statusline').gps()
endfunction

function! aceforeverd#statusline#lsp_status() abort
    if g:my_cmp_source ==? 'nvim_lsp'
        return v:lua.require('lsp-status').status()
    elseif g:my_cmp_source ==? 'coc'
        return coc#status()
    elseif g:my_cmp_source ==? 'vim_lsp'
        return reduce(lsp#get_progress(), { acc, val -> acc .. '/' .. val }, '')
    endif
    return ''
endfunction

function! aceforeverd#statusline#file_size() abort
    return v:lua.require('aceforeverd.utility.statusline').file_size()
endf

function! aceforeverd#statusline#git_diff() abort
    return get(b:, 'gitsigns_status', '')
endf

