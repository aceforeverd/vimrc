" Copyright (C) 2021  Ace <teapot@aceforeverd.com>
"
" This program is free software: you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation, either version 3 of the License, or
" (at your option) any later version.  " " This program is distributed in the hope that it will be useful,
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
        return get(g:, 'coc_status', '')
    elseif g:my_cmp_source ==? 'vim_lsp'
        return reduce(lsp#get_progress(), { acc, val -> acc .. '/' .. val }, '')
    endif
    return ''
endfunction

function! aceforeverd#statusline#file_size() abort
    return v:lua.require('aceforeverd.utility.statusline').file_size()
endfunction

function! aceforeverd#statusline#git_diff() abort
    return get(b:, 'gitsigns_status', '')
endfunction

function! aceforeverd#statusline#git_status() abort
    let [a,m,r] = GitGutterGetHunkSummary()
    let s:diff_str = ''
    if a != 0
        let s:diff_str ..= ' +' .. a
    endif
    if m != 0
        let s:diff_str ..= ' ~' .. m
    endif
    if r != 0
        let s:diff_str ..= ' -' .. r
    endif
    return s:diff_str
endfunction

function! aceforeverd#statusline#lsp_diagnostic() abort
    let cmp = get(g:, 'my_cmp_source', '')
    if cmp ==? 'nvim_lsp'
        return v:lua.require('aceforeverd.utility.statusline').lsp_diagnostic()
    elseif cmp ==? 'coc'
        let info = get(b:, 'coc_diagnostic_info', {})
        if empty(info) | return '' | endif
        let msgs = []
        if get(info, 'error', 0)
            call add(msgs, '  ' .. info['error'])
        endif
        if get(info, 'warning', 0)
            call add(msgs, '  ' .. info['warning'])
        endif
        if get(info, 'information', 0)
            call add(msgs, '  ' .. info['information'])
        endif
        if get(info, 'hint', 0)
            call add(msgs, ' 󰌵' .. info['hint'])
        endif
        return join(msgs, ' ')
    endif
endfunction

function! aceforeverd#statusline#lightline() abort
    let g:lightline = {
      \ 'colorscheme': 'deus',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste', 'git_branch' ],
      \             [ 'readonly', 'modified', 'git_diff', 'diagnostic_count' ],
      \             [ 'lsp_status' ]
      \    ],
      \   'right': [
      \     [ 'lineinfo', 'total_line', 'percent' ],
      \     [ 'fileencoding', 'fileformat', 'spell' ],
      \     [ 'filetype' ]
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
      \   'lsp_status': 'aceforeverd#statusline#lsp_status',
      \   'diagnostic_count': 'aceforeverd#statusline#lsp_diagnostic',
      \   'git_branch': 'FugitiveHead',
      \   'git_diff': 'aceforeverd#statusline#git_status',
      \ }
      \ }
endfunction
