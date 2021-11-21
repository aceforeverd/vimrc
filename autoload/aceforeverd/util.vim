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

" setup all vim plugins and everything other needed
" should only called during installing
function! aceforeverd#util#install() abort
    try
        call dein#install()
    catch /.*/
    endtry
    echomsg "Dein plugins installed\n"
    execute 'PlugInstall --sync'
    echomsg "Vim-Plug plugins installed\n"
    if g:my_cmp_source ==? 'coc'
        " reload plugins so vim can find newly installed plugin like coc.nvim
        execute 'runtime! plugin/**/*.vim'
        execute 'CocUpdateSync'
        echomsg "Coc Plugins installed\n"
    endif
endfunction

" update all plugins managed by different plug manager
function! aceforeverd#util#update() abort
    try
        call dein#update()
    catch /.*/
    endtry
    execute 'PlugUpdate'
    if g:my_cmp_source ==? 'coc'
        execute 'CocUpdate'
    endif
    if has('nvim-0.5')
        execute 'PackerSync'
    endif
endfunction

function! aceforeverd#util#has_float() abort
    " see https://github.com/neoclide/coc.nvim/wiki/F.A.Q#how-to-make-preview-window-shown-aside-with-pum
    return (has('textprop') && has('patch-8.1.1719') && has('*popup_create')) || (exists('*nvim_open_win'))
endfunction

" good util function to investigate highlight staffs
" Note: for treesitter enabled neovim, try 'TSHighlightCapturesUnderCursor'
function! aceforeverd#util#syn_query() abort
    for id in synstack(line('.'), col('.'))
        echomsg synIDattr(id, 'name')
    endfor
endfunction
function! aceforeverd#util#syn_query_verbose() abort
    for id in synstack(line('.'), col('.'))
        execute 'highlight' synIDattr(id, 'name')
    endfor
endfunction

