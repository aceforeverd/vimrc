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

function! aceforeverd#settings#denite_filter_settings() abort
    imap <silent><buffer> <C-o> <Plug>(denite_filter_quit)
endfunction

function! aceforeverd#settings#denite_settings() abort
    nnoremap <silent><buffer><expr> <CR>
                \ denite#do_map('do_action')
    nnoremap <silent><buffer><expr> d
                \ denite#do_map('do_action', 'delete')
    nnoremap <silent><buffer><expr> p
                \ denite#do_map('do_action', 'preview')
    nnoremap <silent><buffer><expr> q
                \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> i
                \ denite#do_map('open_filter_buffer')
    nnoremap <silent><buffer><expr> <Space>
                \ denite#do_map('toggle_select').'j'

    " Change matchers.
    call denite#custom#source(
                \ 'file_mru', 'matchers', ['matcher/fuzzy', 'matcher/project_files'])
    call denite#custom#source(
                \ 'file/rec', 'matchers', ['matcher/cpsm'])

    " Change default action.
    call denite#custom#kind('file', 'default_action', 'split')

    " Add custom menus
    let s:menus = {}

    let s:menus.zsh = {
                \ 'description': 'Edit your import zsh configuration'
                \ }
    let s:menus.zsh.file_candidates = [
                \ ['zshrc', '~/.config/zsh/.zshrc'],
                \ ['zshenv', '~/.zshenv'],
                \ ]

    let s:menus.my_commands = {
                \ 'description': 'Example commands'
                \ }
    let s:menus.my_commands.command_candidates = [
                \ ['Split the window', 'vnew'],
                \ ['Open zsh menu', 'Denite menu:zsh'],
                \ ['Format code', 'FormatCode', 'go,python'],
                \ ]

    call denite#custom#var('menu', 'menus', s:menus) 
    " Ag command on grep source
    call denite#custom#var('grep', 'command', ['dag'])
    call denite#custom#var('grep', 'default_opts',
                \ ['-i', '--vimgrep'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', [])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])

    " Ripgrep command on grep source
    call denite#custom#var('grep', 'command', ['drg'])
    call denite#custom#var('grep', 'default_opts',
                \ ['-i', '--vimgrep', '--no-heading'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])

    " Change ignore_globs
    call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
                \ [ '.git/', '.ropeproject/', '__pycache__/',
                \   'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])

endfunction

