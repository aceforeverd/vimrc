" Copyright (c) 2023 Ace <teapot@aceforeverd.com>
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
"
function! aceforeverd#ui#setup() abort
    " clear all the menus
    call quickui#menu#reset()

    " install a 'File' menu, use [text, command] to represent an item.
    call quickui#menu#install('&File', [
                \ [ '&New File', 'new' ],
                \ [ '&Open File', 'edit .', 'open file in cwd' ],
                \ [ 'Close', 'bdelete' ],
                \ [ '--', '' ],
                \ [ 'Save', 'w'],
                \ [ 'Save As', 'call aceforeverd#ui#saveas()' ],
                \ [ 'Save All', 'wa' ],
                \ [ '--', '' ],
                \ [ 'Exit', 'q' ],
                \ ])

    " script inside %{...} will be evaluated and expanded in the string
    call quickui#menu#install('&Option', [
                \ ['Set &Spell %{&spell? "Off":"On"}', 'set spell!'],
                \ ['Set &Cursor Line %{&cursorline? "Off":"On"}', 'set cursorline!'],
                \ ['Set &Paste %{&paste? "Off":"On"}', 'set paste!'],
                \ ])

    " register HELP menu with weight 10000
    call quickui#menu#install('H&elp', [
                \ ['&Cheatsheet', 'help index', ''],
                \ ['T&ips', 'help tips', ''],
                \ ['--',''],
                \ ['&Tutorial', 'help tutor', ''],
                \ ['&Quick Reference', 'help quickref', ''],
                \ ['&Summary', 'help summary', ''],
                \ ], 10000)

    " enable to display tips in the cmdline
    let g:quickui_show_tip = 1

    " hit space twice to open menu
    noremap <space>m :call quickui#menu#open()<cr>
endfunction

function! aceforeverd#ui#saveas() abort
    let name = quickui#input#open('Save name ?', '')
    if name !=# ''
        execute 'saveas ' . name
    endif
endfunction
