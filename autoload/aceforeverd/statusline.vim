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

function! aceforeverd#statusline#lightline() abort
    let g:lightline = {
      \ 'colorscheme': 'deus',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'modified' ],
      \             [ 'lsp-status' ]
      \    ],
      \   'right': [
      \     [ 'lineinfo', 'percent' ],
      \     [ 'fileencoding', 'fileformat', 'spell' ],
      \     [ 'gps', 'filetype' ]
      \   ]
      \ },
      \ 'inactive': {
      \   'left': [ [ 'filename' ] ],
      \   'right': [ [ 'lineinfo' ], [ 'percent' ] ]
      \ },
      \ 'tabline': {},
      \ 'component_function': {
      \   'gps': 'aceforeverd#statusline#nvim_gps',
      \   'lsp-status': 'aceforeverd#statusline#lsp_status',
      \   'gitbranch': 'FugitiveHead'
      \ }
      \ }
endfunction
