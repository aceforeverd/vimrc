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
    echomsg 'Dein plugins installed'
    execute 'PlugInstall --sync'
    echomsg 'Vim-Plug plugins installed'
    if g:my_cmp_source ==? 'coc'
        " reload plugins so vim can find newly installed plugin like coc.nvim
        execute 'runtime! plugin/**/*.vim'
        execute 'CocUpdateSync'
        echomsg 'Coc Plugins installed'
    endif
endfunction

" update all plugins managed by different plug manager
function! aceforeverd#util#update() abort
    try
        call dein#update()
    catch /.*/
    endtry
    execute 'PlugUpdate'
    execute 'CocUpdate'
endfunction