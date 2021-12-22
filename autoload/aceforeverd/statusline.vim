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
    return v:lua.require('lsp-status').status()
endfunction

function! aceforeverd#statusline#file_size() abort
    return luaeval('require("aceforeverd.utility.statusline").file_size()')
endf

function! aceforeverd#statusline#git_diff()
    return get(b:, 'gitsigns_status', '')
endf

function! aceforeverd#statusline#lightline() abort
    let g:lightline = {
      \ 'colorscheme': 'deus',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'modified','gitbranch', 'git_diff' ],
      \             [ 'lsp-status' ]
      \    ],
      \   'right': [
      \     [ 'lineinfo', 'total_line', 'percent', 'file_size' ],
      \     [ 'fileencoding', 'fileformat', 'spell' ],
      \     [ 'gps', 'filetype' ]
      \   ]
      \ },
      \ 'inactive': {
      \   'left': [ [ 'filename' ] ],
      \   'right': [ [ 'lineinfo' ], [ 'percent' ] ]
      \ },
      \ 'tabline': {},
      \ 'component': {
      \   'total_line': '%L',
      \  },
      \ 'component_function': {
      \   'gps': 'aceforeverd#statusline#nvim_gps',
      \   'lsp-status': 'aceforeverd#statusline#lsp_status',
      \   'gitbranch': 'FugitiveHead',
      \   'file_size': 'aceforeverd#statusline#file_size',
      \   'git_diff': 'aceforeverd#statusline#git_diff'
      \ }
      \ }
endfunction
